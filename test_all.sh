#!/bin/bash
set -e

echo "====================================="
echo " 🔹 Step 0: Очистка корня проекта"
echo "====================================="
rm -rf .ansible .devcontainer .vscode

echo "====================================="
echo " 🔹 Step 1: Docker build & test"
echo "====================================="
docker build -t myapp:latest .
docker run --rm -d --name myapp_test -p 8080:8080 myapp:latest
sleep 3
docker logs myapp_test
docker stop myapp_test

echo "====================================="
echo " 🔹 Step 2: Ansible lint & playbook"
echo "====================================="
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi
source .venv/bin/activate
pip install --upgrade pip
pip install "ansible>=2.14" ansible-lint
ansible-lint ansible/playbook.yml

echo "====================================="
echo " 🔹 Step 3: Terraform validate & fmt"
echo "====================================="
terraform -chdir=terraform validate
terraform -chdir=terraform fmt

echo "====================================="
echo " 🔹 Step 4: Pre-commit checks"
echo "====================================="
pip install pre-commit
pre-commit install
pre-commit run --all-files
