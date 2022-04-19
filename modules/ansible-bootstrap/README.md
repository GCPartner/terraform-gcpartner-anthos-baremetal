## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH Public and Private Key | <pre>object({<br>    public_key  = string<br>    private_key = string<br>  })</pre> | n/a | yes |
| <a name="input_bastion_ip"></a> [bastion\_ip](#input\_bastion\_ip) | The bastion host/admin workstation public IP Address | `string` | n/a | yes |
| <a name="input_cp_node_count"></a> [cp\_node\_count](#input\_cp\_node\_count) | How many control plane nodes to deploy | `number` | n/a | yes |
| <a name="input_worker_node_count"></a> [worker\_node\_count](#input\_worker\_node\_count) | How many worker nodes to deploy | `number` | n/a | yes |
| <a name="input_cp_ips"></a> [cp\_ips](#input\_cp\_ips) | ips for control plane nodes | `list` | n/a | yes |
| <a name="input_worker_ips"></a> [worker\_ips](#input\_worker\_ips) | ips for worker nodes | `list` | n/a | yes |
| <a name="input_private_subnet"></a> [private\_subnet](#input\_private\_subnet) | The private IP space for the cluster | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The ABM cluster name | `string` | n/a | yes |
| <a name="input_abm_version"></a> [abm\_version](#input\_abm\_version) | The version of Anthos Private Mode to install | `string` | n/a | yes |
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | The Operating system to deploy (Only ubuntu\_20\_04 has been tested) | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | The username used to ssh to hosts | `string` | n/a | yes |
| <a name="input_ansible_playbook_version"></a> [ansible\_playbook\_version](#input\_ansible\_playbook\_version) | The version of the ansible playbook to install | `string` | n/a | yes |
| <a name="input_gcp_sa_keys"></a> [gcp\_sa\_keys](#input\_gcp\_sa\_keys) | GCP Service Account Keys | `any` | n/a | yes |

## Outputs

No outputs.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.download_ansible_playbook](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.execute_ansible](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.install_ansible](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.write_ansible_inventory_header](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.write_cp_nodes_to_ansible_inventory](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.write_gcp_sa_keys](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.write_ssh_private_key](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.write_worker_header_to_ansible_inventory](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.write_worker_nodes_to_ansible_inventory](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_abm_version"></a> [abm\_version](#input\_abm\_version) | The version of Anthos Private Mode to install | `string` | n/a | yes |
| <a name="input_ansible_playbook_version"></a> [ansible\_playbook\_version](#input\_ansible\_playbook\_version) | The version of the ansible playbook to install | `string` | n/a | yes |
| <a name="input_ansible_tar_ball"></a> [ansible\_tar\_ball](#input\_ansible\_tar\_ball) | Tarball of the ansible code | `string` | n/a | yes |
| <a name="input_ansible_url"></a> [ansible\_url](#input\_ansible\_url) | URL of the ansible code | `string` | n/a | yes |
| <a name="input_bastion_ip"></a> [bastion\_ip](#input\_bastion\_ip) | The bastion host/admin workstation public IP Address | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The ABM cluster name | `string` | n/a | yes |
| <a name="input_cp_ips"></a> [cp\_ips](#input\_cp\_ips) | ips for control plane nodes | `list(any)` | n/a | yes |
| <a name="input_cp_node_count"></a> [cp\_node\_count](#input\_cp\_node\_count) | How many control plane nodes to deploy | `number` | n/a | yes |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | The project ID to use (Same variable for GCP and EQM) | `string` | n/a | yes |
| <a name="input_gcp_sa_keys"></a> [gcp\_sa\_keys](#input\_gcp\_sa\_keys) | GCP Service Account Keys | `any` | n/a | yes |
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | The Operating system to deploy (Only ubuntu\_20\_04 has been tested) | `string` | n/a | yes |
| <a name="input_private_subnet"></a> [private\_subnet](#input\_private\_subnet) | The private IP space for the cluster | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH Public and Private Key | <pre>object({<br>    public_key  = string<br>    private_key = string<br>  })</pre> | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | The username used to ssh to hosts | `string` | n/a | yes |
| <a name="input_worker_ips"></a> [worker\_ips](#input\_worker\_ips) | ips for worker nodes | `list(any)` | n/a | yes |
| <a name="input_worker_node_count"></a> [worker\_node\_count](#input\_worker\_node\_count) | How many worker nodes to deploy | `number` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->