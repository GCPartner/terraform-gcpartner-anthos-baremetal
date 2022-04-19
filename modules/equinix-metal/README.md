## Variables

No variables.

## Outputs

No outputs.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_metal"></a> [metal](#provider\_metal) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [metal_device.cp_node](https://registry.terraform.io/providers/equinix/metal/latest/docs/resources/device) | resource |
| [metal_device.worker_node](https://registry.terraform.io/providers/equinix/metal/latest/docs/resources/device) | resource |
| [metal_device_network_type.convert_network_cp_node](https://registry.terraform.io/providers/equinix/metal/latest/docs/resources/device_network_type) | resource |
| [metal_device_network_type.convert_network_worker_node](https://registry.terraform.io/providers/equinix/metal/latest/docs/resources/device_network_type) | resource |
| [metal_port_vlan_attachment.private_vlan_attach_cp_node](https://registry.terraform.io/providers/equinix/metal/latest/docs/resources/port_vlan_attachment) | resource |
| [metal_port_vlan_attachment.private_vlan_attach_worker_node](https://registry.terraform.io/providers/equinix/metal/latest/docs/resources/port_vlan_attachment) | resource |
| [metal_project.new_project](https://registry.terraform.io/providers/equinix/metal/latest/docs/resources/project) | resource |
| [metal_ssh_key.ssh_pub_key](https://registry.terraform.io/providers/equinix/metal/latest/docs/resources/ssh_key) | resource |
| [metal_vlan.private_vlan](https://registry.terraform.io/providers/equinix/metal/latest/docs/resources/vlan) | resource |
| [null_resource.cp_node_networking](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.worker_node_networking](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [template_file.cp_node_networking](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.worker_node_networking](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The GKE cluster's name | `string` | n/a | yes |
| <a name="input_cp_node_count"></a> [cp\_node\_count](#input\_cp\_node\_count) | How many control plane nodes to deploy | `number` | n/a | yes |
| <a name="input_create_project"></a> [create\_project](#input\_create\_project) | Create a new Project if this is 'true'. Else use provided 'project\_id' | `bool` | n/a | yes |
| <a name="input_metal_auth_token"></a> [metal\_auth\_token](#input\_metal\_auth\_token) | Equinix Metal API Key | `string` | n/a | yes |
| <a name="input_metal_billing_cycle"></a> [metal\_billing\_cycle](#input\_metal\_billing\_cycle) | How the node will be billed (Not usually changed) | `string` | n/a | yes |
| <a name="input_metal_cp_plan"></a> [metal\_cp\_plan](#input\_metal\_cp\_plan) | Equinix Metal device type to deploy | `string` | n/a | yes |
| <a name="input_metal_facility"></a> [metal\_facility](#input\_metal\_facility) | Equinix Metal Facility to deploy into | `string` | `"ny5"` | no |
| <a name="input_metal_organization_id"></a> [metal\_organization\_id](#input\_metal\_organization\_id) | Equinix Metal Organization ID | `string` | `"null"` | no |
| <a name="input_metal_worker_plan"></a> [metal\_worker\_plan](#input\_metal\_worker\_plan) | Equinix Metal device type to deploy | `string` | n/a | yes |
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | The Operating system of the node | `string` | n/a | yes |
| <a name="input_private_subnet"></a> [private\_subnet](#input\_private\_subnet) | The private IP space for the cluster | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to use, if not creating a new one | `string` | `"null"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project if 'create\_project' is 'true'. | `string` | `"null"` | no |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | n/a | <pre>object({<br>    public_key  = string<br>    private_key = string<br>  })</pre> | n/a | yes |
| <a name="input_worker_node_count"></a> [worker\_node\_count](#input\_worker\_node\_count) | Total number of nodes to delpoy | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_ip"></a> [bastion\_ip](#output\_bastion\_ip) | Bastion Host IP |
| <a name="output_cp_node_ips"></a> [cp\_node\_ips](#output\_cp\_node\_ips) | First IP of control plane nodes |
| <a name="output_username"></a> [username](#output\_username) | n/a |
| <a name="output_worker_node_ips"></a> [worker\_node\_ips](#output\_worker\_node\_ips) | First IP of worker nodes |
<!-- END_TF_DOCS -->