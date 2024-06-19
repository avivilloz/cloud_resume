#!/bin/bash

. vars.sh

mkdir -p temp

terraform -chdir="infra/provision" init
terraform -chdir="infra/provision" apply -auto-approve \
    -var="temp_dir=$temp_dir" \
    -var="aws_region=$aws_region" \
    -var="domain_name=$domain_name" \
    -var="s3_files_dir=$frontend_dir" \
    -var="project_name=$project_name" \
    -var="openapi_path=$openapi_path" \
    -var="cloudflare_api_token=$cloudflare_api_token" \
    -var="deployment_file_path=$deployment_file_path" \
    -var="get_views_count_lambda_dir=$get_views_count_lambda_dir"