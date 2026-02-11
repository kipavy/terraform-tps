resource "docker_image" "this" {
  name = var.image_name
}

resource "docker_container" "this" {
  count      = var.container_count
  name       = "server-${count.index}"
  image      = docker_image.this.image_id
  memory     = var.memory_mb
  privileged = var.privileged

  ports {
    internal = 80
    external = var.start_port + count.index
  }
}