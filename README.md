[![Anthos on Baremetal Website](https://img.shields.io/badge/Website%3A-cloud.google.com/anthos-blue)](https://cloud.google.com/anthos) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://github.com/GCPartner/terraform-gcpartner-anthos-baremetal/pulls) ![](https://img.shields.io/badge/Stability-Experimental-red.svg)
# Automated Anthos on Baremetal via Terraform
This [Terraform](http://terraform.io) module will allow you to deploy [Google Cloud's Anthos on Baremetal](https://cloud.google.com/anthos) on multiple different infrastucture providers.

## Pre-requisites
GCloud installed locally

Terraform (>1.1) installed locally

## Quotas
### For GCP
SSD: 6TB of Disk

vCPUs: 48vCPUs
<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.3 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.3.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_GCP_Auth"></a> [GCP\_Auth](#module\_GCP\_Auth) | ./modules/google-cloud-platform | n/a |
| <a name="module_GCP_Infra"></a> [GCP\_Infra](#module\_GCP\_Infra) | ./modules/google-compute-engine | n/a |
| <a name="module_PNAP_Infra"></a> [PNAP\_Infra](#module\_PNAP\_Infra) | ./modules/phoenixnap | n/a |
| <a name="module_EQM_Infra"></a> [EQM\_Infra](#module\_EQM\_Infra) | ./modules/equinix-metal | n/a |
| <a name="module_Ansible_Bootstrap"></a> [Ansible\_Bootstrap](#module\_Ansible\_Bootstrap) | ./modules/ansible-bootstrap | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.cluster_private_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_string.cluster_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.ssh_key_pair](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

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
| <a name="input_ansible_playbook_version"></a> [ansible\_playbook\_version](#input\_ansible\_playbook\_version) | The version of the ansible playbook to install | `string` | `"v0.0.0"` | no |
| <a name="input_ansible_url"></a> [ansible\_url](#input\_ansible\_url) | URL of the ansible code | `string` | `""` | no |
| <a name="input_ansible_tar_ball"></a> [ansible\_tar\_ball](#input\_ansible\_tar\_ball) | Tarball of the ansible code | `string` | `""` | no |
| <a name="input_pnap_create_network"></a> [pnap\_create\_network](#input\_pnap\_create\_network) | Create a new network if this is 'true'. Else use provided 'pnap\_network\_name' | `bool` | `false` | no |
| <a name="input_pnap_network_name"></a> [pnap\_network\_name](#input\_pnap\_network\_name) | The network\_id to use when creating server in PNAP | `string` | `""` | no |
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
| <a name="output_vlan_id"></a> [vlan\_id](#output\_vlan\_id) | The vLan ID or Network ID for the private network |
| <a name="output_private_subnet"></a> [private\_subnet](#output\_private\_subnet) | The private IP space for the cluster |
<!-- END_TF_DOCS -->