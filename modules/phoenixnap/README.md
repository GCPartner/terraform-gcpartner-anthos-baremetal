<!-- BEGIN_TF_DOCS -->
## Inputs

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
| <a name="input_create_network"></a> [create\_network](#input\_create\_network) | Create a new network if this is 'true'. Else use provided 'p*\_network\_id' | `bool` | n/a | yes |
| <a name="input_public_network_id"></a> [public\_network\_id](#input\_public\_network\_id) | If create\_network=false, this will be the public network used for the deployment. (Only supported in PNAP today) | `string` | n/a | yes |
| <a name="input_private_network_id"></a> [private\_network\_id](#input\_private\_network\_id) | If create\_network=false, this will be the private network used for the deployment. (Only supported in PNAP today) | `string` | n/a | yes |
| <a name="input_network_type"></a> [network\_type](#input\_network\_type) | Deploy the nodes on a 'private' or 'public' network. (Only supported in PNAP today) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_ip"></a> [bastion\_ip](#output\_bastion\_ip) | Bastion Host IP |
| <a name="output_username"></a> [username](#output\_username) | n/a |
| <a name="output_cp_node_ips"></a> [cp\_node\_ips](#output\_cp\_node\_ips) | First IP of control plane nodes |
| <a name="output_worker_node_ips"></a> [worker\_node\_ips](#output\_worker\_node\_ips) | First IP of worker nodes |
| <a name="output_vlan_id"></a> [vlan\_id](#output\_vlan\_id) | The vLan ID used for the private network |
| <a name="output_subnet"></a> [subnet](#output\_subnet) | Public Network CIDR |
| <a name="output_network_details"></a> [network\_details](#output\_network\_details) | The network details for the nodes |
| <a name="output_os_image"></a> [os\_image](#output\_os\_image) | The OS Image used to build the nodes |
<!-- END_TF_DOCS -->