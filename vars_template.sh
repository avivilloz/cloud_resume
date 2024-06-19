#!/bin/bash

# if this is a var_template.sh file and there is no vars.sh file, copy this 
# file localy as vars.sh and assign appropriate values to variables.

# paths
project_base_dir="$HOME/git/cloud_resume"
frontend_dir="$project_base_dir/frontend"
backend_dir="$project_base_dir/backend"
infra_dir="$project_base_dir/infra"
temp_dir="$project_base_dir/temp"
openapi_path="$backend_dir/api/openapi.yaml"
deployment_file_path="$infra_dir/deployment/deployment.yaml"

# lambdas paths
lambdas_dir="$backend_dir/lambdas"
get_views_count_lambda_dir="$lambdas_dir/get_views_count"

# project
aws_region="us-east-1"
project_name=""
domain_name=""

# cloudflare info for creating DNS records
cloudflare_api_token=""
