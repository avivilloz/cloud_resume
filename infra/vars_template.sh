#!/bin/bash

# if this is a var_template.sh file and there is no vars.sh file, copy this 
# file localy as vars.sh and assign appropriate values to variables.

# paths
infra_base_dir="$HOME/git/cloud_resume/infra"

# project
project_name=""
domain_name=""

# cloudflare info for creating DNS records
cloudflare_api_token=""
