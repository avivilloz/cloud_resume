#!/bin/bash

# check if there is exactly one string input
if [ $# -ne 2 ]; then
  echo "Provide <project_base_dir> and <terraform_env> as argument."
  exit 1
fi

project_base_dir=$1
terraform_env=$2

terraform_dir="$project_base_dir/infra/terraform"
ansible_files_dir="$project_base_dir/infra/ansible"
ansible_deploy_path="$ansible_files_dir/website_deploy.yaml"
ansible_tffiles_download_path="$ansible_files_dir/tffiles_download.yaml"
ansible_tffiles_upload_path="$ansible_files_dir/tffiles_upload.yaml"

# download terraform tf files
ansible-playbook $ansible_tffiles_download_path --extra-vars \
  "project_base_dir=$project_base_dir \
  terraform_env=$terraform_env"

# provision website infrastructure
terraform -chdir=$terraform_dir init
terraform -chdir=$terraform_dir apply -auto-approve \
  -var="project_base_dir=$project_base_dir"

# upload terraform tf files
ansible-playbook $ansible_tffiles_upload_path --extra-vars \
  "project_base_dir=$project_base_dir \
  terraform_env=$terraform_env"

# extract vars from terraform tfstate file
cloudfront_distribution_id=$(terraform output \
  -state=$terraform_dir/terraform.tfstate -raw cloudfront_distribution_id)
s3_bucket_name=$(terraform output \
  -state=$terraform_dir/terraform.tfstate -raw s3_bucket_name)
api_url=$(terraform output \
  -state=$terraform_dir/terraform.tfstate -raw api_url)

# deploy website frontend files
ansible-playbook $ansible_deploy_path --extra-vars \
  "cloudfront_distribution_id=$cloudfront_distribution_id \
  project_base_dir=$project_base_dir \
  s3_bucket_name=$s3_bucket_name \
  api_url=$api_url"
