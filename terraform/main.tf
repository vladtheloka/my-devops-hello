terraform {
required_providers {
local = {
source = "hashicorp/local"
version = ">= 2.0.0"
}
}
}


resource "local_file" "deploy_marker" {
filename = "${path.module}/deployed.txt"
content = "Deployed at ${timestamp()}"
}