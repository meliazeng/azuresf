resource "azurerm_virtual_network" "sf_main_vnet" {
    name                = "${virtualNetworkName}"
    # location            = "${computeLocation}"
    resource_group_name = "${azurerm_resource_group.sfgroup.name}"
    address_space       = ["10.0.0.0/16"]
    subnet              = {
        name            = "${subnet0Name}"
        address_prefix  = "10.0.0.0/24"
        security_group  = "${azurerm_network_security_group.sf_nsg_subnet_0.id}"
    }
    depends_on          = ["azurerm_network_security_group.sf_nsg_subnet_0"]

    tags                = {
        resourceType    = "Service Fabric"
        clusterName     = "${clusterName}"
    }       
}

