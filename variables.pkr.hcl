variable "python_image" {
  type    = string
  default = "python:3.9-slim-bullseye"
}

variable "image_tag" {
  type = string
}

variable "ecr_url" {
  type    = string
}
