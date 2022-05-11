import yaml
import subprocess

# Terraform Inputs
ip_cidr = '${ip_cidr}'
private_network_vlan_id = ${vlan_id}
# End Terraform Inputs


with open("/etc/netplan/50-cloud-init.yaml", "r") as stream:
    config = yaml.safe_load(stream)
stream.close()

for key, value in config['network']['vlans'].items():
    if value['id'] == private_network_vlan_id:
        value['addresses'] = [ip_cidr]
if "addresses" in config["network"]["bonds"]["bond0"]:
    del config["network"]["bonds"]["bond0"]["addresses"]

with open("/etc/netplan/50-cloud-init.yaml", "w") as stream:
    yaml.dump(config, stream)
stream.close()

command = "netplan apply"
subprocess.run(command, shell=True)
