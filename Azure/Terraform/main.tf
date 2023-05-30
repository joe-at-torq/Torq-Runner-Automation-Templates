# Torq - Runner Host Automation Template
# Joe Dillig - joe.dillig@torq.io
# Azure Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

provider "azurerm" {

}


resource "azurerm_virtual_machine" "cgc_client_vm" {
  name                  = "torq-runner"
  location              = var.cloud_region
  resource_group_name   = var.resource_group
  network_interface_ids = [azurerm_network_interface.runner_nic.id]
  vm_size               = "Standard_D4s_v3"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "client_osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
    os_profile {
        computer_name  = "performanceclient"
        admin_username = "ubuntu"
        admin_password = "1qaz!QAZ1qaz!QAZ"
        custom_data    = file("custom_data.txt")
    }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}


#Virtual NIC
resource "azurerm_network_interface" "runner_nic" {
  name                = "runner_vm_nic"
  location            = var.cloud_region
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "runner_internal"
    subnet_id                     = var.virtual_subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.runner_publicip.id
  }
}


#Public Ip
resource "azurerm_public_ip" "runner_publicip" {
    name                 = "runner_publicip"
    location             = var.cloud_region
    resource_group_name  = var.resource_group
    allocation_method    = "Dynamic"
}

#NSG
resource "azurerm_network_security_group" "cgc_client_nsg" {
  name                = "torq_runner_nsg"
  location            = var.cloud_region
  resource_group_name = var.resource_group

  security_rule {
    name                       = "any_inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "any_outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#NSG Association
resource "azurerm_network_interface_security_group_association" "client_nsg_associate_client_nic" {
  network_interface_id      = azurerm_network_interface.cgc_client_vm_nic.id
  network_security_group_id = azurerm_network_security_group.cgc_client_nsg.id
}
