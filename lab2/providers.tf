terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

locals {
  is_unix = substr(abspath(path.module), 0, 1) == "/" ? true : false
}

provider "docker" {
  host = {
    windows = "npipe:////./pipe/docker_engine"
    linux   = "unix:///var/run/docker.sock"
  }[local.is_unix ? "linux" : "windows"]
}
