resource "azurerm_lb" "sf_lb_node_type_0" {
    name                                = "LB-${clusterName}-${vmNodeType0Name})"
    location                            = "${computeLocation}"  
    frontend_ip_configuration {
        name                            = "LoadBalancerIPConfig"
        subnet_id                       = ""
        private_ip_address              = "${internalLBAddress}"
        private_ip_address_allocation   = "Static"
    }    
    
    depends_on                          = ["azurerm_virtual_network.sf_main_vnet"]
    tags                                = {
        resourceType                    = "Service Fabric"
        clusterName                     = "${clusterName}"
    }  
}

resource "azurerm_lb_backend_address_pool" "LoadBalancerBEAddressPool" {
    resource_group_name                 = "${azurerm_resource_group.sfgroup.name}"
    loadbalancer_id                     = "${azurerm_lb.sf_lb_node_type_0.id}"
    name                                = "LoadBalancerBEAddressPool"
}

resource "azurerm_lb_rule" "lbrule" {
    resource_group_name                 = "${azurerm_resource_group.sfgroup.name}"
    loadbalancer_id                     = "${azurerm_lb.sf_lb_node_type_0.id}"
    name                                = "LBRule"
    protocol                            = "Tcp"
    frontend_port                       = "${nt0fabricTcpGatewayPort}"
    backend_port                        = "${nt0fabricTcpGatewayPort}"
    probe_id                            = "${azurerm_lb_probe.fabric_gw_probe.id}"
    frontend_ip_configuration_name      = "LoadBalancerIPConfig"
    backend_address_pool_id             = "${azurerm_lb_backend_address_pool.LoadBalancerBEAddressPool.id}"
}

resource "azurerm_lb_rule" "lb_http_rule" {
    resource_group_name                 = "${azurerm_resource_group.sfgroup.name}"
    loadbalancer_id                     = "${azurerm_lb.sf_lb_node_type_0.id}"
    name                                = "LBHttpRule"
    protocol                            = "Tcp"
    frontend_port                       = "${nt0fabricHttpGatewayPort}"
    backend_port                        = "${nt0fabricHttpGatewayPort}"
    probe_id                            = "${azurerm_lb_probe.fabric_http_gw_probe.id}"
    frontend_ip_configuration_name      = "LoadBalancerIPConfig"
    backend_address_pool_id             = "${azurerm_lb_backend_address_pool.LoadBalancerBEAddressPool.id}"
}

resource "azurerm_lb_rule" "lb_appport_rule_1" {
    resource_group_name                 = "${azurerm_resource_group.sfgroup.name}"
    loadbalancer_id                     = "${azurerm_lb.sf_lb_node_type_0.id}"
    name                                = "AppPortLBRule1"
    protocol                            = "Tcp"
    frontend_port                       = "${loadBalancedAppPort1}"
    backend_port                        = "${loadBalancedAppPort1}"
    probe_id                            = "${azurerm_lb_probe.app_port_probe_1.id}"
    frontend_ip_configuration_name      = "LoadBalancerIPConfig"
    backend_address_pool_id             = "${azurerm_lb_backend_address_pool.LoadBalancerBEAddressPool.id}"
}
resource "azurerm_lb_rule" "lb_appport_rule_2" {
    resource_group_name                 = "${azurerm_resource_group.sfgroup.name}"
    loadbalancer_id                     = "${azurerm_lb.sf_lb_node_type_0.id}"
    name                                = "AppPortLBRule2"
    protocol                            = "Tcp"
    frontend_port                       = "${loadBalancedAppPort2}"
    backend_port                        = "${loadBalancedAppPort2}"
    probe_id                            = "${azurerm_lb_probe.app_port_probe_2.id}"
    frontend_ip_configuration_name      = "LoadBalancerIPConfig"
    backend_address_pool_id             = "${azurerm_lb_backend_address_pool.LoadBalancerBEAddressPool.id}"
}

resource "azurerm_lb_probe" "fabric_gw_probe" {
    resource_group_name                 = "${azurerm_resource_group.sfgroup.name}"
    loadbalancer_id                     = "${azurerm_lb.sf_lb_node_type_0.id}"
    name                                = "FabricGatewayProbe"
    port                                = "${nt0fabricTcpGatewayPort}"
}

resource "azurerm_lb_probe" "fabric_http_gw_probe" {
    resource_group_name                 = "${azurerm_resource_group.sfgroup.name}"
    loadbalancer_id                     = "${azurerm_lb.sf_lb_node_type_0.id}"
    name                                = "FabricHttpGatewayProbe"
    port                                = "${nt0fabricHttpGatewayPort}"
}

resource "azurerm_lb_probe" "app_port_probe_1" {
    resource_group_name                 = "${azurerm_resource_group.sfgroup.name}"
    loadbalancer_id                     = "${azurerm_lb.sf_lb_node_type_0.id}"
    name                                = "AppPortProbe1"
    number_of_probes                    = 2
    interval_in_seconds                 = 5
    protocol                            = "tcp"
    port                                = "${loadBalancedAppPort1}"
}

resource "azurerm_lb_probe" "fabricGatewayprobe" {
    resource_group_name                 = "${azurerm_resource_group.sfgroup.name}"
    loadbalancer_id                     = "${azurerm_lb.sf_lb_node_type_0.id}"
    name                                = "AppPortProbe2"
    number_of_probes                    = 2
    interval_in_seconds                 = 5
    protocol                            = "tcp"
    port                                = "${loadBalancedAppPort2}"
}
resource "azurerm_lb_nat_pool" "inboundnat_pools" {
    resource_group_name                 = "${azurerm_resource_group.sfgroup.name}"
    loadbalancer_id                     = "${azurerm_lb.sf_lb_node_type_0.id}"
    name                                = "LoadBalancerBEAddressNatPool"
    protocol                            = "Tcp"
    frontend_port_start                 = 3389
    frontend_port_end                   = 3395
    backend_port                        = 3389
    frontend_ip_configuration_name      = "LoadBalancerIPConfig"
}