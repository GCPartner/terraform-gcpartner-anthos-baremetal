[![Anthos on Baremetal Website](https://img.shields.io/badge/Website-cloud.google.com/anthos-blue)](https://cloud.google.com/anthos) [![Apache License](https://img.shields.io/github/license/GCPartner/phoenixnap-megaport-anthos)](https://github.com/GCPartner/terraform-gcpartner-anthos-baremetal/blob/main/LICENSE) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://github.com/GCPartner/terraform-gcpartner-anthos-baremetal/pulls) ![](https://img.shields.io/badge/Stability-Experimental-red.svg)
# Google Anthos on Baremetal
This [Terraform](http://terraform.io) module will allow you to deploy [Google Cloud's Anthos on Baremetal](https://cloud.google.com/anthos) on Multiple different Clouds (Google Cloud, PhoenixNAP, & Equinix Metal)

The software in this repository has been tested sucessfully on the following hosts:   
1. Ubuntu 20.04 (amd64)
1. macOS 12.4 (macOS Catalina with an Intel processor) 

## Prerequisites 
### Software to Install

* [gcloud command line](https://cloud.google.com/sdk/docs/install)
* [terraform](https://www.terraform.io/downloads)
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### Accounts Needed
* [Google Cloud Account](https://console.cloud.google.com/)
* If Cloud == PNAP
  * [PhoenixNAP](https://phoenixnap.com/bare-metal-cloud)
* If Cloud == EQM
  * [Equinix Metal](https://metal.equinix.com)
### Information to Gather
* Deploy on GCP
   * Your GCP Project ID
* Deploy on PhoenixNAP
  * Client ID
  * Client Secret
* Deploy on Equinix Metal
  * API Auth Token
  * Your Equinix Metal Project ID
## Deployment
### Authenticate to Google Cloud
```bash
gcloud init # Follow any prompts
gcloud auth application-default login # Follown any prompts
```
### Clone the Repo
```bash
git clone https://github.com/GCPartner/terraform-gcpartner-anthos-baremetal.git
cd terraform-gcpartner-anthos-baremetal
```
### Create your *terraform.tfvars*
The following values will need to be modified by you.
#### GCP Minimal Deployment
```bash
cat <<EOF >terraform.tfvars 
gcp_project_id = "my_project"
EOF
```

#### PhoenixNAP Minimal Deployment
```bash
cat <<EOF >terraform.tfvars 
gcp_project_id = "my_project"
cloud = "PNAP"
pnap_client_id = "******"
pnap_client_secret = "******"
pnap_network_name = "my-network"
EOF
```
#### Equinix Metal Minimal Deployment
```bash
cat <<EOF >terraform.tfvars 
gcp_project_id = "my_project"
cloud = "EQM"
metal_auth_token = "a0ec413e-0786-4c17-a302-20ccd8a40c2e"
metal_project_id = "cf27282f-df35-4839-9f15-77e201aa2a2c"
EOF
```
### Initialize Terraform
```bash
terraform init
```
### Deploy the stack
```bash
terraform apply --auto-approve
```
### What success looks like
```
Apply complete! Resources: 79 added, 0 changed, 0 destroyed.

Outputs:

bastion_host_ip = "34.134.208.244"
bastion_host_username = "gcp"
private_subnet = "172.31.254.0/24"
ssh_command = "ssh -i /home/c0dyhi11/.ssh/anthos-cody-qp5we gcp@34.134.208.244"
ssh_key_path = "/home/c0dyhi11/.ssh/anthos-cody-qp5we"
vlan_id = "Not applicable for Google cloud"
```
<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud"></a> [cloud](#input\_cloud) | GCP (Google Cloud Platform), EQM (Equinx Metal), or PNAP (Phoenix Nap) to deploy the 'Nodes' | `string` | `"GCP"` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | Organization ID (GCP or EQM) | `string` | `"null"` | no |
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | The Operating system to deploy (Only ubuntu\_20\_04 has been tested) | `string` | `"ubuntu_20_04"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The ABM cluster name | `string` | `"abm-cluster"` | no |
| <a name="input_create_project"></a> [create\_project](#input\_create\_project) | Create a new Project if this is 'true'. Else use provided 'project\_id' (Unsuported for PNAP) | `bool` | `false` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project if 'create\_project' is 'true'. | `string` | `"abm-lab"` | no |
| <a name="input_abm_version"></a> [abm\_version](#input\_abm\_version) | The version of Anthos on Baremetal to install | `string` | `"1.10.1"` | no |
| <a name="input_private_subnet"></a> [private\_subnet](#input\_private\_subnet) | The private IP space for the cluster | `string` | `"172.31.254.0/24"` | no |
| <a name="input_ha_control_plane"></a> [ha\_control\_plane](#input\_ha\_control\_plane) | Do you want a highly available control plane | `bool` | `true` | no |
| <a name="input_worker_node_count"></a> [worker\_node\_count](#input\_worker\_node\_count) | How many worker nodes to deploy | `number` | `3` | no |
| <a name="input_ansible_playbook_version"></a> [ansible\_playbook\_version](#input\_ansible\_playbook\_version) | The version of the ansible playbook to install | `string` | `"v1.0.0"` | no |
| <a name="input_ansible_url"></a> [ansible\_url](#input\_ansible\_url) | URL of the ansible code | `string` | `"https://github.com/GCPartner/ansible-gcpartner-anthos-baremetal/archive/refs/tags/v1.0.0.tar.gz"` | no |
| <a name="input_ansible_tar_ball"></a> [ansible\_tar\_ball](#input\_ansible\_tar\_ball) | Tarball of the ansible code | `string` | `"v1.0.0.tar.gz"` | no |
| <a name="input_pnap_create_network"></a> [pnap\_create\_network](#input\_pnap\_create\_network) | Create a new network if this is 'true'. Else use provided 'pnap\_network\_name' | `bool` | `false` | no |
| <a name="input_pnap_network_name"></a> [pnap\_network\_name](#input\_pnap\_network\_name) | The name of the network to use when creating servers in PNAP | `string` | `"null"` | no |
| <a name="input_pnap_client_id"></a> [pnap\_client\_id](#input\_pnap\_client\_id) | PhoenixNAP API ID | `string` | `"null"` | no |
| <a name="input_pnap_client_secret"></a> [pnap\_client\_secret](#input\_pnap\_client\_secret) | PhoenixNAP API Secret | `string` | `"null"` | no |
| <a name="input_pnap_location"></a> [pnap\_location](#input\_pnap\_location) | PhoenixNAP Location to deploy into | `string` | `"ASH"` | no |
| <a name="input_pnap_cp_type"></a> [pnap\_cp\_type](#input\_pnap\_cp\_type) | PhoenixNAP server type to deploy for control plane nodes | `string` | `"s2.c1.medium"` | no |
| <a name="input_pnap_worker_type"></a> [pnap\_worker\_type](#input\_pnap\_worker\_type) | PhoenixNAP server type to deploy for worker nodes | `string` | `"s2.c1.medium"` | no |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | The project ID for GCP | `string` | `"null"` | no |
| <a name="input_gcp_cp_instance_type"></a> [gcp\_cp\_instance\_type](#input\_gcp\_cp\_instance\_type) | The GCE instance type for control plane nodes | `string` | `"e2-standard-8"` | no |
| <a name="input_gcp_worker_instance_type"></a> [gcp\_worker\_instance\_type](#input\_gcp\_worker\_instance\_type) | The GCE instance type for worker nodes | `string` | `"e2-standard-8"` | no |
| <a name="input_gcp_zone"></a> [gcp\_zone](#input\_gcp\_zone) | The GCE zone where the instances should reside | `string` | `"us-central1-a"` | no |
| <a name="input_gcp_billing_account"></a> [gcp\_billing\_account](#input\_gcp\_billing\_account) | The GCP billing account to use for the project | `string` | `"null"` | no |
| <a name="input_metal_auth_token"></a> [metal\_auth\_token](#input\_metal\_auth\_token) | Equinix Metal API Key | `string` | `"null"` | no |
| <a name="input_metal_project_id"></a> [metal\_project\_id](#input\_metal\_project\_id) | The project ID to use for EQM | `string` | `"null"` | no |
| <a name="input_metal_facility"></a> [metal\_facility](#input\_metal\_facility) | Equinix Metal Facility to deploy into | `string` | `"ny5"` | no |
| <a name="input_metal_cp_plan"></a> [metal\_cp\_plan](#input\_metal\_cp\_plan) | Equinix Metal device type to deploy for cp nodes | `string` | `"c3.small.x86"` | no |
| <a name="input_metal_worker_plan"></a> [metal\_worker\_plan](#input\_metal\_worker\_plan) | Equinix Metal device type to deploy for worker nodes | `string` | `"c3.small.x86"` | no |
| <a name="input_metal_billing_cycle"></a> [metal\_billing\_cycle](#input\_metal\_billing\_cycle) | How the node will be billed (Not usually changed) | `string` | `"hourly"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ssh_command"></a> [ssh\_command](#output\_ssh\_command) | Command to run to SSH into the bastion host |
| <a name="output_ssh_key_path"></a> [ssh\_key\_path](#output\_ssh\_key\_path) | Path to the SSH Private key for the bastion host |
| <a name="output_bastion_host_ip"></a> [bastion\_host\_ip](#output\_bastion\_host\_ip) | IP Address of the bastion host in the test environment |
| <a name="output_bastion_host_username"></a> [bastion\_host\_username](#output\_bastion\_host\_username) | Username for the bastion host in the test environment |
| <a name="output_vlan_id"></a> [vlan\_id](#output\_vlan\_id) | The vLan ID for the private network |
| <a name="output_private_subnet"></a> [private\_subnet](#output\_private\_subnet) | The private IP space for the cluster |
<!-- END_TF_DOCS -->