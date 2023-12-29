provider "azurerm" { 
    features = {}
}

resource "azurerm_resource_group" "aks_rg" { 
    name     = "myAKSRG" 
    location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" { 
    name                = "myAKSCluster"  
    location            = azurerm_resource_group.aks_rg.location  
    resource_group_name = azurerm_resource_group.aks_rg.name  
    dns_prefix          = "myakscluster"

    default_node_pool {
        name            = "default" 
        node_count      = 1   
        vm_size         = "Standard_DS2_v2"    
        os_disk_size_gb = 30  
    }
    service_principal {
        client_id     = "my-service-principal-client-id"    
        client_secret = "my-service-principal-client-secret" 
    }
    tags = {
        environment = "dev"  
    }
    role_based_access_control_enabled = true
}
output "kube_config" {  
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
}