<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_metal_auth_token"></a> [metal\_auth\_token](#input\_metal\_auth\_token) | Equinix Metal API Key | `string` | n/a | yes |
| <a name="input_metal_organization_id"></a> [metal\_organization\_id](#input\_metal\_organization\_id) | Equinix Metal Organization ID | `string` | n/a | yes |
| <a name="input_create_project"></a> [create\_project](#input\_create\_project) | Create a new Project if this is 'true'. Else use provided 'project\_id' | `bool` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project if 'create\_project' is 'true'. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to use, if not creating a new one | `string` | n/a | yes |
| <a name="input_cp_node_count"></a> [cp\_node\_count](#input\_cp\_node\_count) | How many control plane nodes to deploy | `number` | n/a | yes |
| <a name="input_worker_node_count"></a> [worker\_node\_count](#input\_worker\_node\_count) | Total number of nodes to delpoy | `number` | n/a | yes |
| <a name="input_metal_cp_plan"></a> [metal\_cp\_plan](#input\_metal\_cp\_plan) | Equinix Metal device type to deploy | `string` | n/a | yes |
| <a name="input_metal_worker_plan"></a> [metal\_worker\_plan](#input\_metal\_worker\_plan) | Equinix Metal device type to deploy | `string` | n/a | yes |
| <a name="input_metal_metro"></a> [metal\_metro](#input\_metal\_metro) | Equinix Metal Facility to deploy into | `string` | n/a | yes |
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | The Operating system of the node | `string` | n/a | yes |
| <a name="input_metal_billing_cycle"></a> [metal\_billing\_cycle](#input\_metal\_billing\_cycle) | How the node will be billed (Not usually changed) | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The GKE cluster's name | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | n/a | <pre>object({<br>    public_key  = string<br>    private_key = string<br>  })</pre> | n/a | yes |
| <a name="input_private_subnet"></a> [private\_subnet](#input\_private\_subnet) | The private IP space for the cluster | `string` | n/a | yes |
| <a name="input_metal_lb_vip_subnet_size"></a> [metal\_lb\_vip\_subnet\_size](#input\_metal\_lb\_vip\_subnet\_size) | The number of IPs to have for Load Balancer VIPs (2 are used for Control Plane and Ingress VIPs) | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_ip"></a> [bastion\_ip](#output\_bastion\_ip) | Bastion Host IP |
| <a name="output_username"></a> [username](#output\_username) | n/a |
| <a name="output_cp_node_ips"></a> [cp\_node\_ips](#output\_cp\_node\_ips) | First IP of control plane nodes |
| <a name="output_cp_node_ids"></a> [cp\_node\_ids](#output\_cp\_node\_ids) | ID of control plane nodes |
| <a name="output_worker_node_ips"></a> [worker\_node\_ips](#output\_worker\_node\_ips) | First IP of worker nodes |
| <a name="output_worker_node_ids"></a> [worker\_node\_ids](#output\_worker\_node\_ids) | ID of worker nodes |
| <a name="output_os_image"></a> [os\_image](#output\_os\_image) | The OS Image used to build the nodes |
| <a name="output_lb_vip_subnet"></a> [lb\_vip\_subnet](#output\_lb\_vip\_subnet) | The load balancer VIP network subnet |
| <a name="output_lb_vip_id"></a> [lb\_vip\_id](#output\_lb\_vip\_id) | The load balancer VIP network id |
<!-- END_TF_DOCS -->