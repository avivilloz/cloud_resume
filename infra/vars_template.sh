#!/bin/bash

# if this is a var_template.sh file and there is no vars.sh file, copy this 
# file localy as vars.sh and assign appropriate values to variables.

# paths
project_base_dir="$HOME/git/cloud_resume"
bin_dir="$project_base_dir/bin"
frontend_dir="$project_base_dir/frontend"
backend_dir="$project_base_dir/backend"
infra_base_dir="$project_base_dir/infra"
openapi_path="$backend_dir/api/openapi.yaml"

# lambdas paths
lambdas_dir="$backend_dir/lambdas"
get_views_count_lambda_dir="$lambdas_dir/get_views_count"

# project
aws_region="us-east-1"
project_name=""
domain_name=""

# cloudflare info for creating DNS records
cloudflare_api_token=""

# aws info
aws_account_id=""
