## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | The Operating system to deploy (Only ubuntu\_20\_04 has been tested) | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The ABM cluster name | `string` | n/a | yes |
| <a name="input_pnap_location"></a> [pnap\_location](#input\_pnap\_location) | PhoenixNAP Location to deploy into | `string` | n/a | yes |
| <a name="input_cp_node_count"></a> [cp\_node\_count](#input\_cp\_node\_count) | How many control plane nodes to deploy | `number` | n/a | yes |
| <a name="input_worker_node_count"></a> [worker\_node\_count](#input\_worker\_node\_count) | How many worker nodes to deploy | `number` | n/a | yes |
| <a name="input_pnap_cp_type"></a> [pnap\_cp\_type](#input\_pnap\_cp\_type) | PhoenixNAP server type to deploy for control plane nodes | `string` | n/a | yes |
| <a name="input_pnap_worker_type"></a> [pnap\_worker\_type](#input\_pnap\_worker\_type) | PhoenixNAP server type to deploy for worker nodes | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH Public and Private Key | <pre>object({<br>    public_key  = string<br>    private_key = string<br>  })</pre> | n/a | yes |
| <a name="input_private_subnet"></a> [private\_subnet](#input\_private\_subnet) | The private IP space for the cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_ip"></a> [bastion\_ip](#output\_bastion\_ip) | Bastion Host IP |
| <a name="output_username"></a> [username](#output\_username) | n/a |
| <a name="output_cp_node_ips"></a> [cp\_node\_ips](#output\_cp\_node\_ips) | First IP of control plane nodes |
| <a name="output_worker_node_ips"></a> [worker\_node\_ips](#output\_worker\_node\_ips) | First IP of worker nodes |

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_pnap"></a> [pnap](#provider\_pnap) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.node_networking_cp](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.node_networking_worker](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [pnap_private_network.new_network](https://registry.terraform.io/providers/phoenixnap/pnap/latest/docs/resources/private_network) | resource |
| [pnap_server.cp_node](https://registry.terraform.io/providers/phoenixnap/pnap/latest/docs/resources/server) | resource |
| [pnap_server.worker_node](https://registry.terraform.io/providers/phoenixnap/pnap/latest/docs/resources/server) | resource |
| [template_file.node_networking_cp](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.node_networking_worker](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The ABM cluster name | `string` | n/a | yes |
| <a name="input_cp_node_count"></a> [cp\_node\_count](#input\_cp\_node\_count) | How many control plane nodes to deploy | `number` | n/a | yes |
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | The Operating system to deploy (Only ubuntu\_20\_04 has been tested) | `string` | n/a | yes |
| <a name="input_pnap_cp_type"></a> [pnap\_cp\_type](#input\_pnap\_cp\_type) | PhoenixNAP server type to deploy for control plane nodes | `string` | n/a | yes |
| <a name="input_pnap_location"></a> [pnap\_location](#input\_pnap\_location) | PhoenixNAP Location to deploy into | `string` | n/a | yes |
| <a name="input_pnap_worker_type"></a> [pnap\_worker\_type](#input\_pnap\_worker\_type) | PhoenixNAP server type to deploy for worker nodes | `string` | n/a | yes |
| <a name="input_private_subnet"></a> [private\_subnet](#input\_private\_subnet) | The private IP space for the cluster | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH Public and Private Key | <pre>object({<br>    public_key  = string<br>    private_key = string<br>  })</pre> | n/a | yes |
| <a name="input_worker_node_count"></a> [worker\_node\_count](#input\_worker\_node\_count) | How many worker nodes to deploy | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_ip"></a> [bastion\_ip](#output\_bastion\_ip) | Bastion Host IP |
| <a name="output_cp_node_ips"></a> [cp\_node\_ips](#output\_cp\_node\_ips) | First IP of control plane nodes |
| <a name="output_username"></a> [username](#output\_username) | n/a |
| <a name="output_worker_node_ips"></a> [worker\_node\_ips](#output\_worker\_node\_ips) | First IP of worker nodes |
<!-- END_TF_DOCS -->