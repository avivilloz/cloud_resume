#!/bin/bash

# if this is a var_template.sh file and there is no vars.sh file, copy this 
# file localy as vars.sh and assign appropriate values to variables.

# paths
project_base_dir="$HOME/git/cloud_resume"
frontend_dir="$projects_base_dir/frontend"
infra_base_dir="$projects_base_dir/infra"
api_json_path="$projects_base_dir/backend/openapi.yaml"
get_views_count_path="$projects_base_dir/backend/get_views_count.py"

# project
project_name=""
domain_name=""

# cloudflare info for creating DNS records
cloudflare_api_token=""