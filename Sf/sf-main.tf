resource "azurerm_resource_group" "sfgroup" {
  name     = "service-fabric-resources"
  location = "${computeLocation}"
}

resource "azurerm_storage_account" "sf_support_log_sa" {
    name                = "${supportLogStorageAccountName}"
    location            = "${computeLocation}"
    resource_group_name = "${azurerm_resource_group.sfgroup.name}"
    account_kind        = "Storage"
    tags                = {
        resourceType    = "Service Fabric"
        clusterName     = "${clusterName}"
    }   
}

resource "azurerm_storage_account" "sf_application_diagnostics_sa"  {
    name                = "${applicationDiagnosticsStorageAccountName}"
    location            = "${computeLocation}"
    resource_group_name = "${azurerm_resource_group.sfgroup.name}" 
    account_kind        = "Storage"
    tags                = {
        resourceType    = "Service Fabric"
        clusterName     = "${clusterName}"
    }   
}

resource "azurerm_virtual_machine_scale_set" "sf_main_ss" {
    name = "${vmNodeType0Name}"
}

resource  "azurerm_service_fabric_cluster" "sf_main_cluster" {
    name = "${clusterName}"
}
