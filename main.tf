terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "postgresql_too_many_locks_acquired" {
  source    = "./modules/postgresql_too_many_locks_acquired"

  providers = {
    shoreline = shoreline
  }
}