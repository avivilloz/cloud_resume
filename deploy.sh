#!/bin/bash

project_base_dir="/home/deck/git/cloud_resume"

terraform_env="development"
terraform_envs_dir="$project_base_dir/infra/terraform/environments"
terraform_env_path="$terraform_envs_dir/$terraform_env"

ansible_files_dir="$project_base_dir/infra/ansible"
ansible_deploy_path="$ansible_files_dir/website_deploy.yaml"
ansible_tffiles_download_path="$ansible_files_dir/tffiles_download.yaml"
ansible_tffiles_upload_path="$ansible_files_dir/tffiles_upload.yaml"

ansible-playbook $ansible_tffiles_download_path --extra-vars "project_base_dir=$project_base_dir"

terraform -chdir=$terraform_env_path init
terraform -chdir=$terraform_env_path apply -auto-approve -var="project_base_dir=$project_base_dir"

ansible-playbook $ansible_tffiles_upload_path --extra-vars "project_base_dir=$project_base_dir"

s3_bucket_name=$(terraform output -state=$terraform_env_path/terraform.tfstate -raw s3_bucket_name)
api_stage_endpoint=$(terraform output -state=$terraform_env_path/terraform.tfstate -raw api_stage_endpoint)
cloudfront_distribution_id=$(terraform output -state=$terraform_env_path/terraform.tfstate -raw cloudfront_distribution_id)

ansible-playbook $ansible_deploy_path --extra-vars "project_base_dir=$project_base_dir s3_bucket_name=$s3_bucket_name api_stage_endpoint=$api_stage_endpoint cloudfront_distribution_id=$cloudfront_distribution_id"