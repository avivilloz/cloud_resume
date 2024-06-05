#!/bin/bash

# if this is a var_template.sh file and there is no vars.sh file, copy this 
# file localy as vars.sh and assign appropriate values to variables.

infra_base_dir="$HOME/git/cloud_resume/infra"
project_name=""
domain_name=""

export CLOUDFLARE_API_TOKEN=""
