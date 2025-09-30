FROM ubuntu:23.04

# Базовые утилиты
RUN apt update && apt install -y python3 python3-pip curl git docker.io unzip wget

# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Terraform
RUN wget https://releases.hashicorp.com/terraform/1.6.3/terraform_1.6.3_linux_amd64.zip && \
    unzip terraform_1.6.3_linux_amd64.zip -d /usr/local/bin && rm terraform_1.6.3_linux_amd64.zip

# Ansible
RUN apt install -y ansible
