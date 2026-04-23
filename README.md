# Universal IaC Blueprint (Terraform + Ansible)

Репозиторий представляет собой модульный фреймворк для развертывания масштабируемой и защищенной инфраструктуры в AWS. Проект построен на принципах **Immutable Infrastructure** и **Zero-Trust Networking**.

## Архитектура решения

Проект разделен на три независимых слоя:
1.  **State Layer (Bootstrap):** Инициализация S3 и DynamoDB для хранения Terraform State.
2.  **Infrastructure Layer (Terraform):** Модульное описание сети (VPC) и вычислительных ресурсов (EC2).
3.  **Configuration Layer (Ansible):** Конфигурация узлов через динамический инвентарь (Docker Engine + Observability Stack).

## Безопасность и соответствие

* **Network Hardening:** Доступ к SSH (порт 22) и HTTP (порт 80) ограничен на уровне Security Groups. Доступ разрешен только для доверенных IP, указанных в переменных.
* **State Locking:** Механизм блокировок через DynamoDB предотвращает коллизии при одновременном запуске пайплайнов.
* **Secret Management:** Для защиты чувствительных данных в Ansible рекомендуется использование `ansible-vault`.

## Порядок развертывания

### 1. Подготовка окружения (macOS)
Убедитесь, что установлены необходимые инструменты:
```bash
brew install terraform ansible awscli tflint
```

### 2. Инициализация удаленного стейта
Перед запуском основной инфраструктуры необходимо подготовить хранилище:
1. Перейдите в `terraform/bootstrap`.
2. Выполните `terraform init && terraform apply`.
3. Полученное значение `state_bucket_name` вставьте в файл `terraform/environments/stage/providers.tf` в поле `bucket`.

### 3. Развертывание инфраструктуры
Инфраструктура параметризована под конкретные окружения. 

1. Определите разрешенные IP в `terraform/environments/stage/terraform.tfvars`:
```hcl
allowed_ips = ["YOUR_IP/32"] # Обязательно для доступа по SSH
```
2. Используйте `Makefile` для управления:
```bash
make init ENV=stage
make plan ENV=stage
make apply ENV=stage
```

### 4. Конфигурация узлов (Ansible)
Ansible автоматически обнаруживает ресурсы AWS по тегам `ManagedBy: Terraform`.

1. Проверьте доступность хостов:
```bash
cd ansible
ansible-inventory --graph
```
2. Запустите плейбук:
```bash
ansible-playbook site.yml
```

## CI/CD Workflow
В репозитории настроены GitHub Actions для автоматизации проверок:
* **Linting:** Проверка синтаксиса Terraform (`tflint`) и Ansible (`ansible-lint`).
* **Validation:** Автоматический `terraform plan` при создании Pull Request.

**Необходимые Secrets в GitHub:**
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

## Мониторинг
После завершения работы Ansible на целевых узлах разворачиваются:
* **Node Exporter (порт 9100):** Метрики операционной системы.
* **cAdvisor (порт 8080):** Метрики контейнеров.

---
*Проект разработан с учетом требований к отказоустойчивости и минимизации вектора атак.*
