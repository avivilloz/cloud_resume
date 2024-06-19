#!/bin/bash

vars_dir="$(dirname "${BASH_SOURCE[0]}")"

. "$vars_dir/vars.sh"

mkdir -p $temp_dir

terraform -chdir="$infra_dir/provision" init
terraform -chdir="$infra_dir/provision" apply -auto-approve \
    -var="project_name=$project_name" \
    -var="domain_name=$domain_name" \
    -var="cloudflare_api_token=$cloudflare_api_token" \
    -var="openapi_path=$openapi_path" \
    -var="temp_dir=$temp_dir" \
    -var="get_views_count_lambda_dir=$get_views_count_lambda_dir" \
    -var="aws_region=$aws_region" \
    -var="s3_files_dir=$frontend_dir" \
    -var="deployment_file_path=$deployment_file_path"
