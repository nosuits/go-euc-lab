# Secret in files

| Tool | Location of secret file |
| --- | --- |
| Packer | `/packer/vmware/vsphere.pckvars.hcl` |
| Terraform | `/terraform/vmware/infra/terraform.tfvars` |

Please make sure that you have these files in your `.gitignore` file so that your passwords don't end up in the repository online.

# Packer 

/packer/vmware/vsphere.pckvars.hcl

```
common_vm_version = 20
vm_guest_os_type = "windows2019srv_64Guest"

build_username = "go"
build_password = "BuildPassword!"

vsphere_endpoint = "vSphereServer.domain.tld"
vsphere_username = "vSphereUsername@domain.tld"
vsphere_password = "vSpherePassword"
vsphere_datacenter = "vSphereDatacenter"
vsphere_cluster = "vSphereCluster"
vsphere_datastore = "vSphereDatastore"
vsphere_network = "VM Network"
vsphere_folder = "vSphereTemplateFolder"

common_iso_datastore = "vSphereDatastoreISO"

iso_path = "ISOs"
iso_file = "en-us_windows_server_2022_updated_dec_2022_x64_dvd_14fe3ddc.iso"

```

---

# Terraform

/terraform/vmware/infra/terraform.tfvars

```
vsphere_server="vSphere.domain.tld"
vsphere_user="administrator@domain.tld"
vsphere_password="vSpherePassword"
vsphere_hosts=[2]
esx_password="ESXiPasswors"
vsphere_datacenter="vSphereDatacenter"
vsphere_cluster="vSphereCluster"
vsphere_nic="VM Network"
vsphere_datastore="vSphereDatastore"
vsphere_source_template_windows="vSphereTemplateName"
delivery="cvad"
domain_admin_password="vSphereDomainAdminPassword"
local_admin_password="vSphereLocalAdminPassword"
```