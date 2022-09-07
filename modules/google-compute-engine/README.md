<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | The Operating system to deploy (Only ubuntu\_20\_04 has been tested) | `string` | n/a | yes |
| <a name="input_create_project"></a> [create\_project](#input\_create\_project) | Create a new Project if this is 'true'. Else use provided 'project\_id' | `bool` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project if 'create\_project' is 'true'. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to use (Same variable for GCP and EQM) | `string` | n/a | yes |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | Organization ID (GCP or EQM) | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | n/a | <pre>object({<br>    public_key  = string<br>    private_key = string<br>  })</pre> | n/a | yes |
| <a name="input_gcp_cp_instance_type"></a> [gcp\_cp\_instance\_type](#input\_gcp\_cp\_instance\_type) | The GCE instance type for control plane nodes | `string` | n/a | yes |
| <a name="input_gcp_worker_instance_type"></a> [gcp\_worker\_instance\_type](#input\_gcp\_worker\_instance\_type) | The GCE instance type for worker nodes | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The GKE cluster name | `string` | n/a | yes |
| <a name="input_gcp_zone"></a> [gcp\_zone](#input\_gcp\_zone) | The GCE zone where the instances should reside | `string` | n/a | yes |
| <a name="input_gcp_billing_account"></a> [gcp\_billing\_account](#input\_gcp\_billing\_account) | The GCP billing account to use for the project | `string` | n/a | yes |
| <a name="input_private_subnet"></a> [private\_subnet](#input\_private\_subnet) | The private IP space for the cluster | `string` | n/a | yes |
| <a name="input_cp_node_count"></a> [cp\_node\_count](#input\_cp\_node\_count) | How many control plane nodes to deploy | `number` | n/a | yes |
| <a name="input_worker_node_count"></a> [worker\_node\_count](#input\_worker\_node\_count) | How many worker nodes to deploy | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_ip"></a> [bastion\_ip](#output\_bastion\_ip) | n/a |
| <a name="output_username"></a> [username](#output\_username) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_worker_node_ips"></a> [worker\_node\_ips](#output\_worker\_node\_ips) | First IP of worker nodes |
| <a name="output_cp_node_ips"></a> [cp\_node\_ips](#output\_cp\_node\_ips) | First IP of cp nodes |
| <a name="output_vlan_id"></a> [vlan\_id](#output\_vlan\_id) | Not applicable for Google cloud |
| <a name="output_subnet"></a> [subnet](#output\_subnet) | The private IP space for the cluster |
<!-- END_TF_DOCS -->