resource "azurerm_postgresql_server" "emojify_db" {
  count = "${var.authserver_enabled == true ? 1 : 0}"

  name                = "emojify-db"
  resource_group_name = "${data.terraform_remote_state.core.resource_group_name}"
  location            = "${data.terraform_remote_state.core.location}"

  sku {
    name     = "B_Gen5_1"
    capacity = 1
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "psqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "9.5"
  ssl_enforcement              = "Disabled"
}

resource "azurerm_postgresql_database" "emojify_db" {
  count = "${var.authserver_enabled == true ? 1 : 0}"

  name                = "keratin"
  resource_group_name = "${data.terraform_remote_state.core.resource_group_name}"
  server_name         = "${azurerm_postgresql_server.emojify_db.name}"

  charset   = "UTF8"
  collation = "English_United States.1252"
}

# Allow internal ingress
resource "azurerm_postgresql_firewall_rule" "emojify_db" {
  count = "${var.authserver_enabled == true ? 1 : 0}"

  name                = "azure"
  resource_group_name = "${data.terraform_remote_state.core.resource_group_name}"
  server_name         = "${azurerm_postgresql_server.emojify_db.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
