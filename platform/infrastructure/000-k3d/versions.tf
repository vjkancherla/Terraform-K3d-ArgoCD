terraform {
  required_version = ">= 1.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.8"
    }
    random = {
      source  = "hashicorp/random"
      version = "2.2.1"
    }
  }
}

provider "docker" {}
provider "random" {}