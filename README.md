# my-devops-hello


Простой тестовый проект для практики DevOps: build Docker image → deploy в Kubernetes → автоматизация через Ansible/Terraform → CI/CD (GitLab CI).


Краткое содержание:
- `app/` — простое Flask-приложение + Dockerfile
- `k8s/` — Kubernetes-манифесты (Deployment + Service)
- `ansible/` — пример playbook для локального деплоя/сборки
- `terraform/` — минимальный пример (локальный `local_file`)
- `.gitlab-ci.yml` — минимальная схема pipeline (build → deploy)

--- README: quick run & VS Code ---


1. Локально (без Kubernetes):
- Сборка образа: `docker build -t myapp:latest ./app`
- Запуск: `docker run -p 8080:8080 myapp:latest`
- Проверить: `curl http://localhost:8080/`


2. В Kubernetes (kind/k3d/minikube):
- Собрать образ и загрузить в локальный кластер (или использовать registry):
- Для kind: `kind load docker-image myapp:latest`
- Затем `kubectl apply -f k8s/`
- Проверить `kubectl get pods,svc` и `kubectl port-forward svc/myapp-service 8080:80`


3. Ansible: `ansible-playbook ansible/playbook.yml` (потребуются community.docker collection)
4. Terraform: `terraform init && terraform apply` (создаст `deployed.txt`)


--- VS Code рекомендации ---
- Установи расширение **Remote - WSL** для работы с проектом в WSL напрямую.
- Открой проект: `code ~/projects/my-devops-hello`.
- (Опционально) настроить DevContainer:
- Создать `.devcontainer/devcontainer.json` с образом Ubuntu + Docker.
- Это позволит запускать контейнеры, kubectl, Ansible прямо из VS Code.
- Можно создать `launch.json` для отладки Flask приложения в VS Code:
```json
{
"version": "0.2.0",
"configurations": [
{
"name": "Python: Flask",
"type": "python",
"request": "launch",
"program": "${workspaceFolder}/app/app.py",
"console": "integratedTerminal"
}
]
}
```
- Git интеграция: используем встроенный Source Control для коммитов и пуша.