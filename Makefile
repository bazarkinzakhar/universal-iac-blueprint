.PHONY: help init plan apply destroy lint

ENV ?= stage
TF_DIR = terraform/environments/$(ENV)

help: ## отобразить список доступных команд
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## инициализация Terraform
	cd $(TF_DIR) && terraform init

plan: ## отобразить план изменений инфраструктуры
	cd $(TF_DIR) && terraform plan

apply: ## применить изменения инфраструктуры
	cd $(TF_DIR) && terraform apply

destroy: ## удалить инфраструктуру
	cd $(TF_DIR) && terraform destroy

lint: ## запуск проверки кода (tflint, ansible-lint)
	tflint --recursive
	ansible-lint ansible/site.yml