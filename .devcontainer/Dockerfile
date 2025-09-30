FROM ubuntu:22.04


# Устанавливаем базовые утилиты без лишнего
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
python3 python3-pip curl git unzip wget ca-certificates gnupg lsb-release sudo && \
apt-get clean && rm -rf /var/lib/apt/lists/*


# Docker CLI (демон берется с хоста)
RUN curl -fsSL https://get.docker.com | sh


# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# Terraform
RUN wget https://releases.hashicorp.com/terraform/1.6.3/terraform_1.6.3_linux_amd64.zip && \
unzip terraform_1.6.3_linux_amd64.zip -d /usr/local/bin && rm terraform_1.6.3_linux_amd64.zip


# Ansible
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ansible && \
apt-get clean && rm -rf /var/lib/apt/lists/*