#!/bin/bash

. vars.sh

terraform -chdir="$infra_base_dir/provision" init
terraform -chdir="$infra_base_dir/provision" apply -auto-approve \
    -var="project_name=$project_name"

ansible-playbook "$infra_base_dir/deployment/deployment.yaml" \
    -e "project_name=$project_name"
