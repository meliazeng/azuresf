resource "azurerm_virtual_machine_scale_set" "mainss" {
    name                = "${vmNodeType0Name}"
    resource_group_name = "${azurerm_resource_group.sfgroup.name}"

    automatic_os_upgrade = true
    overprovision = "${overProvision}"
    upgrade_policy_mode  = "Automatic"

    sku {
        name     = "${vmNodeType0Size}"
        tier     = "Standard"
        capacity = "${nt0InstanceCount}"
    }

    extension {
        name                        = ""
        type                        = "ServiceFabricNode"
        type_handler_version        = "1.0"
        auto_upgrade_minor_version  = true
        protected_settings = <<EOT
{
  "StorageAccountKey1": "bar",
  "StorageAccountKey2": ["boop"]
}
EOT
       
        publisher                   = "Microsoft.Azure.ServiceFabric"
        settings = <<EOT
{
  "clusterEndpoint": "[reference(parameters('clusterName')).clusterEndpoint]",
  "nodeTypeRef": "[variables('vmNodeType0Name')]",
  "dataPath": "D:\\SvcFab",
  "durabilityLevel": "Bronze",
  "enableParallelJobs": true,
  "nicPrefixOverride": "[variables('subnet0Prefix')]",
  "certificate": {
    "thumbprint": "[parameters('certificateThumbprint')]",
    "x509StoreName": "[parameters('certificateStoreValue')]"
    }
}
EOT

    storage_profile_image_reference {
        publisher               = "${vmImagePublisher}"
        offer                   = "${vmImageOffer}"
        sku                     = "${vmImageSku}"
        version                 = "${vmImageVersion}"
    }

    storage_profile_os_disk {
        name                    = ""
        caching                 = "ReadOnly"
        create_option           = "FromImage"
        managed_disk_type       = "${storageAccountType}"
    }

    storage_profile_image_reference {
        publisher               = "${vmImagePublisher}"
        offer                   = "${vmImageOffer}"
        sku                     = "${vmImageSku}"
        version                 = "${vmImageVersion}"
    }

    os_profile {
        admin_password          = "${adminPassword}"
        computer_name_prefix    = "${vmNodeType0Name}"
        admin_username          = "${adminUsername}"
        source_vault_id         = "${sourceVaultValue}"
        vault_certificates {
            certificate_url     = "${certificateUrlValue}"
            certificate_store   = "${certificateStoreValue}"
        }
    }

    network_profile {
        name    = "terraformnetworkprofile"
        primary = true

        ip_configuration {
            name                                   = "TestIPConfiguration"
            primary                                = true
            subnet_id                              = "${azurerm_subnet.test.id}"
            load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.bpepool.id}"]
            load_balancer_inbound_nat_rules_ids    = ["${azurerm_lb_nat_pool.lbnatpool.id}"]
        }
    }

    tags = {
        resourceType    = "Service Fabric"
        clusterName     = "${clusterName}"
    }    
  
}
