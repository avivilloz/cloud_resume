#!/bin/bash

# mkdir -p temp

production_env="infra/terraform/environments/production"

terraform -chdir=$production_env init
terraform -chdir=$production_env apply -auto-approve