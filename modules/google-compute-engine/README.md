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
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_address.bastion_ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_attached_disk.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk) | resource |
| [google_compute_disk.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_disk) | resource |
| [google_compute_firewall.allow-all-internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow-icmp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow-ssh](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_instance.cp_node](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_instance.worker_node](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_network.gpc_network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_project_metadata.ssh_pub_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_project_metadata) | resource |
| [google_compute_router.cloud-router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.nat-gateway](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_project.new_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project) | resource |
| [google_project_service.compute_engine](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [null_resource.cp_node_networking](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.worker_node_networking](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.project_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [template_file.cp_node_networking](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.worker_node_networking](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The GKE cluster name | `string` | n/a | yes |
| <a name="input_cp_node_count"></a> [cp\_node\_count](#input\_cp\_node\_count) | How many control plane nodes to deploy | `number` | n/a | yes |
| <a name="input_create_project"></a> [create\_project](#input\_create\_project) | Create a new Project if this is 'true'. Else use provided 'project\_id' | `bool` | n/a | yes |
| <a name="input_gcp_billing_account"></a> [gcp\_billing\_account](#input\_gcp\_billing\_account) | The GCP billing account to use for the project | `string` | n/a | yes |
| <a name="input_gcp_cp_instance_type"></a> [gcp\_cp\_instance\_type](#input\_gcp\_cp\_instance\_type) | The GCE instance type for control plane nodes | `string` | n/a | yes |
| <a name="input_gcp_worker_instance_type"></a> [gcp\_worker\_instance\_type](#input\_gcp\_worker\_instance\_type) | The GCE instance type for worker nodes | `string` | n/a | yes |
| <a name="input_gcp_zone"></a> [gcp\_zone](#input\_gcp\_zone) | The GCE zone where the instances should reside | `string` | n/a | yes |
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | The Operating system to deploy (Only ubuntu\_20\_04 has been tested) | `string` | n/a | yes |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | Organization ID (GCP or EQM) | `string` | n/a | yes |
| <a name="input_private_subnet"></a> [private\_subnet](#input\_private\_subnet) | The private IP space for the cluster | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to use (Same variable for GCP and EQM) | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project if 'create\_project' is 'true'. | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | n/a | <pre>object({<br>    public_key  = string<br>    private_key = string<br>  })</pre> | n/a | yes |
| <a name="input_worker_node_count"></a> [worker\_node\_count](#input\_worker\_node\_count) | How many worker nodes to deploy | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_ip"></a> [bastion\_ip](#output\_bastion\_ip) | n/a |
| <a name="output_cp_node_ips"></a> [cp\_node\_ips](#output\_cp\_node\_ips) | First IP of cp nodes |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_username"></a> [username](#output\_username) | n/a |
| <a name="output_worker_node_ips"></a> [worker\_node\_ips](#output\_worker\_node\_ips) | First IP of worker nodes |
<!-- END_TF_DOCS -->