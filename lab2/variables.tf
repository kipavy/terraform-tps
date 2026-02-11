variable "container_count" {
    type = number
    default = 1
}
variable "image_name" {
    type = string
    default = "nginx:latest"
}
variable "memory_mb" {
    type = number
    default = 512
}
variable "privileged" {
    type = bool
    default = false
}
variable "start_port" {
    type = number
    default = 8000
}