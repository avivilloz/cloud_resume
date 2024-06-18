#!/bin/bash

. vars.sh

terraform -chdir="$infra_base_dir" init
terraform -chdir="$infra_base_dir" apply -auto-approve \
    -var="project_name=$project_name" \
    -var="domain_name=$domain_name" \
    -var="cloudflare_api_token=$cloudflare_api_token" \
    -var="openapi_path=$openapi_path" \
    -var="bin_dir=$bin_dir" \
    -var="get_views_count_lambda_dir=$get_views_count_lambda_dir" \
    -var="aws_account_id=$aws_account_id" \
    -var="aws_region=$aws_region" \
    -var="s3_files_dir=$frontend_dir" \
    -var="deployment_file_path=$deployment_file_path"
