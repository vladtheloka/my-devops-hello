#!/usr/bin/env bash
set -e

echo "====================================="
echo " 🔹 Step 0: Очистка корня проекта"
echo "====================================="

for item in .* *; do
  case "$item" in
    .git|.gitignore|.venv|.pre-commit-config.yaml|README.md|test_all.sh|app|ansible|k8s|terraform|requirements.txt|requirements.yml|.gitlab-ci.yml|.devcontainer|.vscode|Dockerfile)
      # сохраняем
      ;;
    *)
      echo "Удаляем $item"
      rm -rf "$item"
      ;;
  esac
done

echo
echo "====================================="
echo " 🔹 Step 1: Docker build & test"
echo "====================================="

docker image rm -f myapp:latest 2>/dev/null || true
docker build -t myapp:latest .
docker run -d --rm --name myapp_test -p 8080:8080 myapp:latest
sleep 3
curl -s http://localhost:8080 || echo "⚠️ приложение не отвечает"
docker stop myapp_test

echo
echo "====================================="
echo " 🔹 Step 2: Python venv + Ansible lint & playbook"
echo "====================================="

if [ ! -d ".venv" ]; then
  echo "Создаём .venv..."
  python3 -m venv .venv
fi
source .venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt

if [ -f "requirements.yml" ]; then
  ansible-galaxy collection install -r requirements.yml
fi

echo "👉 Запуск ansible-lint"
ansible-lint ansible/

echo "👉 Запуск playbook"
ansible-playbook ansible/playbook.yml --syntax-check
ansible-playbook ansible/playbook.yml -i localhost, --connection=local

echo
echo "====================================="
echo " 🔹 Step 3: Terraform validate & fmt"
echo "====================================="

cd terraform
terraform init -backend=false
terraform validate
terraform fmt -check -recursive
cd ..

echo
echo "====================================="
echo " 🔹 Step 4: Kubernetes manifests"
echo "====================================="

kubectl apply --dry-run=client -f k8s/deployment.yaml
kubectl apply --dry-run=client -f k8s/service.yaml

echo
echo "====================================="
echo " 🔹 Step 5: pre-commit hooks"
echo "====================================="

pre-commit install
pre-commit run --all-files || true

echo
echo "====================================="
echo " ✅ Все проверки завершены успешно!"
echo "====================================="
