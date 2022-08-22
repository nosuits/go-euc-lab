module "ActiveDirectory" {
  source                = "./modules/vmware.vsphere.vm.windows"
  vm_name               = "${local.environment_abbreviations[terraform.workspace]}-dc"
  vm_cpu                = 4
  vm_memory             = 8192
  local_admin_password  = var.local_admin_password
  domain                = local.ad_domain_fqdn
  domain_admin          = var.domain_admin
  domain_admin_password = var.domain_admin_password

  network_address                = cidrhost(local.virtual_network_cidr_address[terraform.workspace], 1)   #matches to the 1st IP address of the address space I.E. "172.16.0.1"
  network_gateway                = cidrhost(local.virtual_network_cidr_address[terraform.workspace], 254) #matches to the 254th IP address of the address space I.E. "172.16.0.254"
  virtual_network_portgroup_name = local.virtual_network_portgroup_name[terraform.workspace]

  vsphere_datacenter      = local.vsphere_datacenter
  vsphere_datastore       = local.vsphere_datastore
  vsphere_cluster         = local.vsphere_cluster
  vsphere_source_template = local.vsphere_source_template_windows
}

module "ManagementServer" {
  source    = "./modules/vmware.vsphere.vm.windows"
  vm_name   = "${local.environment_abbreviations[terraform.workspace]}-mgnt"
  vm_cpu    = 4
  vm_memory = 4096
  vm_disks = [{
    unit_number = 0
    label       = "disk0"
    size        = 128
  }]
  local_admin_password  = var.local_admin_password
  domain                = local.ad_domain_fqdn
  domain_admin          = var.domain_admin
  domain_admin_password = var.domain_admin_password

  virtual_network_portgroup_name = local.virtual_network_portgroup_name[terraform.workspace]

  vsphere_datacenter      = local.vsphere_datacenter
  vsphere_datastore       = local.vsphere_datastore
  vsphere_cluster         = local.vsphere_cluster
  vsphere_source_template = local.vsphere_source_template_windows
}

module "FileServer" {
  source    = "./modules/vmware.vsphere.vm.windows"
  vm_name   = "${local.environment_abbreviations[terraform.workspace]}-fs"
  vm_cpu    = 4
  vm_memory = 4096
  vm_disks = [{
    unit_number = 0
    label       = "os"
    size        = 100
    }, {
    unit_number = 1
    label       = "data"
    size        = 512
  }]

  virtual_network_portgroup_name = local.virtual_network_portgroup_name[terraform.workspace]

  local_admin_password  = var.local_admin_password
  domain                = local.ad_domain_fqdn
  domain_admin          = var.domain_admin
  domain_admin_password = var.domain_admin_password

  vsphere_datacenter      = local.vsphere_datacenter
  vsphere_datastore       = local.vsphere_datastore
  vsphere_cluster         = local.vsphere_cluster
  vsphere_source_template = local.vsphere_source_template_windows
}

module "RemoteGateway" {
  source    = "./modules/vmware.vsphere.vm.windows"
  vm_name   = "${local.environment_abbreviations[terraform.workspace]}-rdgw"
  vm_cpu    = 4
  vm_memory = 4096

  network_address                = cidrhost(local.virtual_network_cidr_address[terraform.workspace], 11)  
  network_gateway                = cidrhost(local.virtual_network_cidr_address[terraform.workspace], 254)
  virtual_network_portgroup_name = local.virtual_network_portgroup_name[terraform.workspace]

  local_admin_password  = var.local_admin_password
  domain                = local.ad_domain_fqdn
  domain_admin          = var.domain_admin
  domain_admin_password = var.domain_admin_password

  vsphere_datacenter      = local.vsphere_datacenter
  vsphere_datastore       = local.vsphere_datastore
  vsphere_cluster         = local.vsphere_cluster
  vsphere_source_template = local.vsphere_source_template_windows
}

module "SQLServer" {

  source    = "./modules/vmware.vsphere.vm.windows"
  vm_name   = "${local.environment_abbreviations[terraform.workspace]}-sql"
  vm_cpu    = 4
  vm_memory = 8192
  vm_disks = [{
    unit_number = 0
    label       = "os"
    size        = 100
    }, {
    unit_number = 1
    label       = "mssqldata"
    size        = 64
  }]
  virtual_network_portgroup_name = local.virtual_network_portgroup_name[terraform.workspace]

  local_admin_password  = var.local_admin_password
  domain                = local.ad_domain_fqdn
  domain_admin          = var.domain_admin
  domain_admin_password = var.domain_admin_password

  vsphere_datacenter      = local.vsphere_datacenter
  vsphere_datastore       = local.vsphere_datastore
  vsphere_cluster         = local.vsphere_cluster
  vsphere_source_template = local.vsphere_source_template_windows
}

module "CitrixLicenseServer" {
  count  = local.delivery_solutions[var.delivery] == "cvad" ? 1 : 0

  source    = "./modules/vmware.vsphere.vm.windows"
  vm_name   = "${local.environment_abbreviations[terraform.workspace]}-ctxlic"
  vm_cpu    = 2
  vm_memory = 4096
  vm_disks = [{
    unit_number = 0
    label       = "disk0"
    size        = 128
  }]
  
  virtual_network_portgroup_name = local.virtual_network_portgroup_name[terraform.workspace]

  local_admin_password  = var.local_admin_password
  domain                = local.ad_domain_fqdn
  domain_admin          = var.domain_admin
  domain_admin_password = var.domain_admin_password

  vsphere_datacenter      = local.vsphere_datacenter
  vsphere_datastore       = local.vsphere_datastore
  vsphere_cluster         = local.vsphere_cluster
  vsphere_source_template = local.vsphere_source_template_windows
}


module "CitrixDeliveryControler" {
  count  = local.delivery_solutions[var.delivery] == "cvad" ? 1 : 0

  source    = "./modules/vmware.vsphere.vm.windows"
  vm_name   = "${local.environment_abbreviations[terraform.workspace]}-ctxddc"
  vm_cpu    = 4
  vm_memory = 8192
  vm_disks = [{
    unit_number = 0
    label       = "disk0"
    size        = 128
  }]

  virtual_network_portgroup_name = local.virtual_network_portgroup_name[terraform.workspace]

  local_admin_password  = var.local_admin_password
  domain                = local.ad_domain_fqdn
  domain_admin          = var.domain_admin
  domain_admin_password = var.domain_admin_password

  vsphere_datacenter      = local.vsphere_datacenter
  vsphere_datastore       = local.vsphere_datastore
  vsphere_cluster         = local.vsphere_cluster
  vsphere_source_template = local.vsphere_source_template_windows
}

module "CitrixStorefront" {
  count  = local.delivery_solutions[var.delivery] == "cvad" ? 1 : 0

  source    = "./modules/vmware.vsphere.vm.windows"
  vm_name   = "${local.environment_abbreviations[terraform.workspace]}-ctxsf"
  vm_cpu    = 2
  vm_memory = 6144
  vm_disks = [{
    unit_number = 0
    label       = "disk0"
    size        = 128
  }]

  virtual_network_portgroup_name = local.virtual_network_portgroup_name[terraform.workspace]

  local_admin_password  = var.local_admin_password
  domain                = local.ad_domain_fqdn
  domain_admin          = var.domain_admin
  domain_admin_password = var.domain_admin_password

  vsphere_datacenter      = local.vsphere_datacenter
  vsphere_datastore       = local.vsphere_datastore
  vsphere_cluster         = local.vsphere_cluster
  vsphere_source_template = local.vsphere_source_template_windows
}

# module "Bots" {
#   source    = "./modules/vmware.vsphere.vm.windows"
#   vm_count  = 10
#   vm_name   = "${local.environment_abbreviations[terraform.workspace]}-bot"
#   vm_cpu    = 4
#   vm_memory = 8192
#   vm_disks = [{
#     unit_number = 0
#     label       = "disk0"
#     size        = 128
#   }]
#   local_admin_password  = var.local_admin_password
#   domain                = local.ad_domain_fqdn
#   domain_admin          = var.domain_admin
#   domain_admin_password = var.domain_admin_password

#   virtual_network_portgroup_name = local.virtual_network_portgroup_name[terraform.workspace]

#   vsphere_datacenter      = local.vsphere_datacenter
#   vsphere_datastore       = local.vsphere_datastore
#   vsphere_cluster         = local.vsphere_cluster
#   vsphere_source_template = local.vsphere_source_template_windows
# }