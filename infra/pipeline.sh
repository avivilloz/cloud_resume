#!/bin/bash

. vars.sh

terraform -chdir="$infra_base_dir/provision" init
terraform -chdir="$infra_base_dir/provision" apply -auto-approve \
    -var="project_name=$project_name" \
    -var="domain_name=$domain_name" \
    -var="cloudflare_api_token=$cloudflare_api_token" \
    -var="cloudflare_zone_id=$cloudflare_zone_id" 

ansible-playbook "$infra_base_dir/deployment/deployment.yaml" \
    -e "project_name=$project_name"
