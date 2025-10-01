terraform {
  required_version = ">= 1.5.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_image" "myapp" {
  name         = "myapp:latest"
  build {
    context = "${path.module}/../app"
  }
}

resource "docker_container" "myapp" {
  name  = "myapp_tf_test"
  image = docker_image.myapp.image_id
  ports {
    internal = 8080
    external = 8080
  }
}
