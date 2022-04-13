locals {
  git_repo_name           = "ansible-gcpartner-anthos-baremetal"
  ansible_execute_timeout = 1800
  unix_home               = var.username == "root" ? "/root" : "/home/${var.username}"
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
    destination = "${local.unix_home}/.ssh/id_rsa"
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

      "BIN_PATH=$HOME/.local/bin",
      "if [ \"$(whoami)\" = \"root\" ]; then",
      "BIN_PATH=/usr/local/bin",
      "fi",
      "mkdir -p $HOME/bootstrap",
      "cd $HOME/bootstrap",
      "curl -LO https://bootstrap.pypa.io/pip/3.6/get-pip.py",
      "(which python3>/dev/null 2>&1) || (apt install python3 -y>/dev/null 2>&1) || (dnf install python3 -y>/dev/null 2>&1)",
      "python3 get-pip.py --no-warn-script-location",
      "$BIN_PATH/pip install virtualenv",
      "$BIN_PATH/virtualenv ansible",
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
    destination = "${local.unix_home}/bootstrap/gcp_keys/${each.key}.json"
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
      "curl -LO ${var.ansible_url}",
      "tar -xf ${var.ansible_tar_ball}",
      "rm -rf ${var.ansible_tar_ball}",
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

  # INFO: run in while loop, 3 times
  # INFO: if exit code is non zero, run it again, max 3 times
  provisioner "remote-exec" {
    inline = [
      ". $HOME/bootstrap/ansible/bin/activate",
      "cd $HOME/bootstrap/${local.git_repo_name}",
      "start=3",
      "while [ $start -gt 0 ]",
      "do",
      "/usr/bin/timeout ${local.ansible_execute_timeout} ansible-playbook -i inventory site.yaml -b",
      "if [ $? -eq 0 ]; then",
      "break",
      "fi",
      "start=$((start-1))",
      "done",
    ]
  }
}

