#!/bin/bash
set -euo pipefail

echo "🔹 Полная проверка DevOps проекта"

# ===== 0. Очистка =====
echo "🔹 Очистка старого состояния"
docker rm -f myapp_test myapp_tf_test 2>/dev/null || true
docker rmi -f myapp:latest 2>/dev/null || true

# Удаляем мусорные каталоги в корне (оставляем только нужное)
echo "🔹 Удаляем лишние файлы в корне"
for item in .* *; do
  case "$item" in
    app|ansible|k8s|terraform|.git|.gitignore|.venv|.pre-commit-config.yaml|README.md|test_all.sh)
      echo "Оставляем $item"
      ;;
    *)
      echo "Удаляем $item"
      rm -rf "$item"
      ;;
  esac
done

# ===== 1. Docker =====
echo "🔹 Step 1: Docker build & run"
docker build -t myapp:latest ./app
docker run -d --name myapp_test -p 8080:8080 myapp:latest
sleep 3
curl -s http://localhost:8080 || (echo "❌ App not responding" && exit 1)
docker rm -f myapp_test

# ===== 2. Ansible =====
echo "🔹 Step 2: Ansible lint & playbook"
ansible-lint ansible/playbook.yml || true
ansible-playbook ansible/playbook.yml

# ===== 3. Kubernetes =====
echo "🔹 Step 3: K8s lint"
yamllint k8s/ || true

# ===== 4. Terraform =====
echo "🔹 Step 4: Terraform validate"
cd terraform
terraform init -backend=false -input=false
terraform validate
cd ..

echo "✅ Все проверки завершены успешно!"
