locals {
  ansible_test_url      = "https://github.com/GCPartner/ansible-gcpartner-anthos-baremetal/archive/refs/heads/v0.0.1.tar.gz"
  ansible_prod_url      = "https://github.com/GCPartner/ansible-gcpartner-anthos-baremetal/archive/refs/tags/${var.ansible_playbook_version}.tar.gz"
  ansible_url           = coalesce(local.ansible_test_url, local.ansible_prod_url)
  ansible_test_tar_ball = "v0.0.1.tar.gz"
  ansible_prod_tar_ball = "${var.ansible_playbook_version}.tar.gz"
  ansible_tar_ball      = coalesce(local.ansible_test_tar_ball, local.ansible_prod_tar_ball)


  git_repo_name = "ansible-gcpartner-anthos-baremetal"
}

resource "null_resource" "write_ssh_private_key" {
  connection {
    type        = "ssh"
    user        = var.username
    private_key = var.ssh_key.private_key
    host        = var.bastion_ip
  }

  provisioner "file" {
    content     = var.ssh_key.private_key
    destination = "$HOME/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = ["chmod 0400 $HOME/.ssh/id_rsa"]
  }
}

resource "null_resource" "install_ansible" {
  connection {
    type        = "ssh"
    user        = var.username
    private_key = var.ssh_key.private_key
    host        = var.bastion_ip
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p $HOME/bootstrap",
      "cd $HOME/bootstrap",
      "curl -LO https://bootstrap.pypa.io/get-pip.py",
      "python3 get-pip.py --no-warn-script-location",
      "$HOME/.local/bin/pip install virtualenv",
      "$HOME/.local/bin/virtualenv ansible",
      ". ansible/bin/activate",
      "pip -q install ansible netaddr",
      "echo '[defaults]' > $HOME/.ansible.cfg",
      "echo 'host_key_checking = False' >> $HOME/.ansible.cfg",
      "rm -f get-pip.py"
    ]
  }
}

resource "null_resource" "write_gcp_sa_keys" {
  for_each = var.gcp_sa_keys

  connection {
    type        = "ssh"
    user        = var.username
    private_key = var.ssh_key.private_key
    host        = var.bastion_ip
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p $HOME/bootstrap/gcp_keys"
    ]
  }

  provisioner "file" {
    content     = base64decode(each.value)
    destination = "$HOME/bootstrap/gcp_keys/${each.key}.json"
  }
}

resource "null_resource" "download_ansible_playbook" {
  connection {
    type        = "ssh"
    user        = var.username
    private_key = var.ssh_key.private_key
    host        = var.bastion_ip
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p $HOME/bootstrap",
      "cd  $HOME/bootstrap",
      "curl -LO ${local.ansible_url}",
      "tar -xf ${local.ansible_tar_ball}",
      "rm -rf ${local.ansible_tar_ball}",
      "mv ${local.git_repo_name}* ${local.git_repo_name}"
    ]
  }
}

resource "null_resource" "write_ansible_inventory_header" {
  depends_on = [
    null_resource.download_ansible_playbook
  ]

  connection {
    type        = "ssh"
    user        = var.username
    private_key = var.ssh_key.private_key
    host        = var.bastion_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo '[all:vars]' > $HOME/bootstrap/${local.git_repo_name}/inventory",
      "echo 'private_subnet=${var.private_subnet}' >> $HOME/bootstrap/${local.git_repo_name}/inventory",
      "echo 'cluster_name=${var.cluster_name}' >> $HOME/bootstrap/${local.git_repo_name}/inventory",
      "echo 'username=${var.username}' >> $HOME/bootstrap/${local.git_repo_name}/inventory",
      "echo 'cp_node_count=${var.cp_node_count}' >> $HOME/bootstrap/${local.git_repo_name}/inventory",
      "echo 'worker_node_count=${var.worker_node_count}' >> $HOME/bootstrap/${local.git_repo_name}/inventory",
      "echo 'gcp_project_id=${var.gcp_project_id}' >> $HOME/bootstrap/${local.git_repo_name}/inventory",
      "echo home_path=$HOME >> $HOME/bootstrap/${local.git_repo_name}/inventory",
      "echo '[bootstrap_node]' >> $HOME/bootstrap/${local.git_repo_name}/inventory",
      "echo '127.0.0.1' >> $HOME/bootstrap/${local.git_repo_name}/inventory",
      "echo '[cp_nodes]' >> $HOME/bootstrap/${local.git_repo_name}/inventory"
    ]
  }
}

resource "null_resource" "write_cp_nodes_to_ansible_inventory" {
  count = var.cp_node_count
  depends_on = [
    null_resource.write_ansible_inventory_header
  ]

  connection {
    type        = "ssh"
    user        = var.username
    private_key = var.ssh_key.private_key
    host        = var.bastion_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sleep ${count.index + 1}",
      "echo '${var.cp_ips[count.index]}' >> $HOME/bootstrap/${local.git_repo_name}/inventory"
    ]
  }
}

resource "null_resource" "write_worker_header_to_ansible_inventory" {
  depends_on = [
    null_resource.write_cp_nodes_to_ansible_inventory
  ]

  connection {
    type        = "ssh"
    user        = var.username
    private_key = var.ssh_key.private_key
    host        = var.bastion_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo '[worker_nodes]' >> $HOME/bootstrap/${local.git_repo_name}/inventory"
    ]
  }
}

resource "null_resource" "write_worker_nodes_to_ansible_inventory" {
  count = var.worker_node_count
  depends_on = [
    null_resource.write_worker_header_to_ansible_inventory
  ]

  connection {
    type        = "ssh"
    user        = var.username
    private_key = var.ssh_key.private_key
    host        = var.bastion_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sleep ${count.index + 1}",
      "echo '${var.worker_ips[count.index]}' >> $HOME/bootstrap/${local.git_repo_name}/inventory"
    ]
  }
}

resource "null_resource" "execute_ansible" {
  connection {
    type        = "ssh"
    user        = var.username
    private_key = var.ssh_key.private_key
    host        = var.bastion_ip
  }
  depends_on = [
    null_resource.download_ansible_playbook,
    null_resource.write_worker_nodes_to_ansible_inventory,
    null_resource.install_ansible
  ]


  provisioner "remote-exec" {
    inline = [
      ". $HOME/bootstrap/ansible/bin/activate",
      "cd $HOME/bootstrap/${local.git_repo_name}",
      "ansible-playbook -i inventory site.yaml -b",
    ]
  }
}

