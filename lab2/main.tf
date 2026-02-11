resource "docker_image" "this" {
  name = var.image_name
}

resource "docker_container" "this" {
  count      = var.container_count
  name       = "server-${count.index}"
  image      = docker_image.this.image_id
  memory     = var.memory_mb
  privileged = var.privileged

  volumes {
    host_path      = abspath("${path.module}/nginx/default.conf")
    container_path = "/etc/nginx/conf.d/default.conf"
    read_only      = true
  }

  ports {
    internal = 80
    external = var.start_port + count.index
  }
}