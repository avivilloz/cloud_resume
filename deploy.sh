#!/bin/bash

terraform_production_env_path="infra/terraform/environments/production"
ansible_deploy_path="infra/ansible/website_deploy.yaml"

terraform -chdir=$terraform_production_env_path init
terraform -chdir=$terraform_production_env_path apply -auto-approve

# ansible-playbook $ansible_deploy_path