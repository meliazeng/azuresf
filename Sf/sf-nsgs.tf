resource "azurerm_network_security_group" "sf_nsg_subnet_0" {
    resource_group_name = "${azurerm_resource_group.sfgroup.name}"
    name                = "nsg-${subnet0Name}"
    location            = "${computeLocation}"
    tags                = {
        resourceType    = "Service Fabric"
        clusterName     = "${clusterName}"
    }   
}

resource "azurerm_network_security_rule" "allowappport1" {
    name                        = "allowAppPort1"
    description                 = "allow public application port 1"
    priority                    = 2001
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "${loadBalancedAppPort1}"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    network_security_group_name = "${azurerm_network_security_group.sf_nsg_subnet_0.name}"
}

resource "azurerm_network_security_rule" "allowappport2" {
    name                        = "allowAppPort2"
    description                 = "allow public application port 2"
    priority                    = 2002
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "${loadBalancedAppPort2}"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    network_security_group_name = "${azurerm_network_security_group.sf_nsg_subnet_0.name}"
}

resource "azurerm_network_security_rule" "allowsvcfabportal" {
    name                        = "allowSvcFabPortal"
    description                 = "allow port used to access the fabric cluster web portal"
    priority                    = 3900
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "${nt0fabricHttpGatewayPort}"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    network_security_group_name = "${azurerm_network_security_group.sf_nsg_subnet_0.name}"
}

resource "azurerm_network_security_rule" "allowsvcfabclient" {
    name                        = "allowSvcFabClient"
    description                 = "allow port used by the fabric client (includes powershell)"
    priority                    = 3910
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "${nt0fabricTcpGatewayPort}"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    network_security_group_name = "${azurerm_network_security_group.sf_nsg_subnet_0.name}"
}

resource "azurerm_network_security_rule" "allowsvcfabcluser" {
    name                        = "allowSvcFabCluser"
    description                 = "allow ports within vnet that are used by the fabric to talk between nodes"
    priority                    = 3920
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "1025-1027"
    source_address_prefix       = "10.0.0.0/24"
    destination_address_prefix  = "*"
    network_security_group_name = "${azurerm_network_security_group.sf_nsg_subnet_0.name}"
}

resource "azurerm_network_security_rule" "allowsvcfabephemeral" {
    name                        = "allowSvcFabEphemeral"
    description                 = "allow fabric ephemeral ports within the vnet"
    priority                    = 3930
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "${nt0ephemeralStartPort}-${nt0ephemeralEndPort}"
    source_address_prefix       = "10.0.0.0/24"
    destination_address_prefix  = "*"
    network_security_group_name = "${azurerm_network_security_group.sf_nsg_subnet_0.name}"
}

resource "azurerm_network_security_rule" "allowsvcfabapplication" {
    name                        = "allowSvcFabApplication"
    description                 = "allow fabric ephemeral ports within the vnet"
    priority                    = 3930
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "${nt0applicationStartPort}-${nt0applicationEndPort}"
    source_address_prefix       = "10.0.0.0/24"
    destination_address_prefix  = "*"
    network_security_group_name = "${azurerm_network_security_group.sf_nsg_subnet_0.name}"
}

resource "azurerm_network_security_rule" "allowsvcfabsmb" {
    name                        = "allowSvcFabSMB"
    description                 = "allow SMB traffic within the net, used by fabric to move packages around"
    priority                    = 3950
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "445"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    network_security_group_name = "${azurerm_network_security_group.sf_nsg_subnet_0.name}"
}

resource "azurerm_network_security_rule" "allowvnetrdp" {
    name                        = "allowVNetRDP"
    description                 = "allow RDP within the net"
    priority                    = 3960
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    network_security_group_name = "${azurerm_network_security_group.sf_nsg_subnet_0.name}"
}

resource "azurerm_network_security_rule" "allowsvcfabreverseproxy" {
    name                        = "allowSvcFabReverseProxy"
    description                 = "allow port used to access the fabric cluster using reverse proxy"
    priority                    = 3980
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "${nt0reverseProxyEndpointPort}"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    network_security_group_name = "${azurerm_network_security_group.sf_nsg_subnet_0.name}"
}

resource "azurerm_network_security_rule" "blockall" {
    name                        = "blockAll"
    description                 = "block all traffic except what we've explicitly allowed"
    priority                    = 4095
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    network_security_group_name = "${azurerm_network_security_group.sf_nsg_subnet_0.name}"
}