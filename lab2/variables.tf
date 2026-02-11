variable "container_count" {
    type = number
    default = 1
    validation {
        condition = var.container_count > 0
        error_message = "The number of containers must be greater than 0."
    }
}
variable "image_name" {
    type = string
    default = "nginx:latest"
    validation {
        condition = length(var.image_name) > 0
        error_message = "The image name cannot be empty."
    }
}
variable "memory_mb" {
    type = number
    default = 512
    validation {
        condition = var.memory_mb > 0
        error_message = "Memory must be greater than 0 MB."
    }
}
variable "privileged" {
    type = bool
    default = false
    validation {
        condition = var.privileged == true || var.privileged == false
        error_message = "Privileged must be a boolean value."
    }
}
variable "start_port" {
    type = number
    default = 8000
    validation {
        condition = var.start_port > 0 && var.start_port < 65536
        error_message = "Start port must be between 1 and 65535."
    }
}