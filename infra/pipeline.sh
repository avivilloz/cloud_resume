#!/bin/bash

. vars.sh

terraform -chdir="$infra_base_dir/provision" init
terraform -chdir="$infra_base_dir/provision" apply -auto-approve \
    -var="project_name=$project_name" \
    -var="domain_name=$domain_name" \
    -var="cloudflare_api_token=$cloudflare_api_token" \
    -var="api_json_path=$api_json_path" \
    -var="get_views_count_path=$get_views_count_path"

ansible-playbook "$infra_base_dir/deployment/deployment.yaml" \
    -e "project_name=$project_name" \
    -e "s3_files_path=$frontend_dir"
