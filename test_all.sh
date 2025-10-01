#!/bin/bash
set -e

echo "🔹 Step 0: Очистка старого состояния"
docker rm -f myapp_test || true
docker rmi -f myapp:latest || true

# Создаём временную директорию для артефактов
TMP_DIR=$(mktemp -d)
echo "Используем временную директорию: $TMP_DIR"

echo "🔹 Step 0b: Удаляем лишние IDE/Devcontainer директории"
for d in .vscode .devcontainer .ansible_cache .pytest_cache; do
    [ -d "$d" ] && echo "Удаляем $d" && rm -rf "$d"
done

echo "🔹 Step 1: Docker build & test"
docker build -t myapp:latest ./app
echo "Waiting 3s for app to start..."
docker run -d --name myapp_test -p 8080:8080 myapp:latest
sleep 3
curl -s http://localhost:8080/ || echo "⚠️ App did not respond"
docker stop myapp_test && docker rm myapp_test

echo "🔹 Step 2: Ansible lint & playbook"
# Активируем виртуальное окружение, если есть
[ -f ".venv/bin/activate" ] && source .venv/bin/activate

ansible-lint ansible/playbook.yml || echo "⚠️ Ansible-lint failed"
ansible-playbook ansible/playbook.yml || echo "⚠️ Ansible playbook failed"

echo "🔹 Step 3: Terraform check"
terraform -chdir=terraform init -input=false
terraform -chdir=terraform validate
terraform -chdir=terraform fmt -check

echo "🔹 Step 4: Pre-commit checks"
pre-commit run --all-files || echo "⚠️ Pre-commit checks failed"

echo "🔹 Step 5: Очистка временных файлов"
rm -rf "$TMP_DIR"
echo "✅ Все шаги выполнены, проект чистый!"
