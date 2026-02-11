terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

module "yannick" {
  source = "git::https://gitlab.com/imt-mines-ales-yc/terraform/tps.git//modules/nginx_container"

  CONTAINER_SPECIFICATIONS = {
    image         = "nginx:latest"
    memory        = 256
    privileged    = false
    internal_port = 80
  }

  CONTAINERS_TO_SPAWN = {
    number     = 3
    first_port = 9000
  }
}