#!/bin/bash

# check if there is exactly 2 string inputs
if [ $# -ne 2 ]; then
  echo "Provide <project_base_dir> and <terraform_env> as arguments."
  echo "<terraform_env> can be 'development' or 'production'."
  exit 1
fi

echo "In order to deploy infra with terraform, or to perform other infra 
related tasks the following environment variables might need to be added: 
1- AWS_DEFAULT_REGION
2- AWS_ACCESS_KEY_ID
3- AWS_SECRET_ACCESS_KEY
4- CLOUDFLARE_API_TOKEN"

echo "Did you add the mentioned environment variables? [y/n]"
read ans
if [ $ans = "n" ]; then
  echo "Please add the environment variables before running this script."
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
echo "Do you want to download terraform tf files? [y/n]"
read ans
if [ $ans = "y" ]; then
  ansible-playbook $ansible_tffiles_download_path \
    -e "project_base_dir=$project_base_dir" \
    -e "terraform_env=$terraform_env"
fi

# provision website infrastructure and backend
echo "Do you want to provision website infrastructure and backend? [y/n]"
read ans
if [ $ans = "y" ]; then
  terraform -chdir=$terraform_dir init
  terraform -chdir=$terraform_dir apply -auto-approve \
    -var="project_base_dir=$project_base_dir"
fi

# upload terraform tf files
echo "Do you want to upload terraform tf files? [y/n]"
read ans
if [ $ans = "y" ]; then
  ansible-playbook $ansible_tffiles_upload_path \
    -e "project_base_dir=$project_base_dir" \
    -e "terraform_env=$terraform_env"
fi

# deploy website frontend files
echo "Do you want to deploy website frontend files? [y/n]"
read ans
if [ $ans = "y" ]; then
  # extract vars from terraform tfstate file
  cloudfront_distribution_id=$(terraform output \
    -state=$terraform_dir/terraform.tfstate -raw cloudfront_distribution_id)
  s3_bucket_name=$(terraform output \
    -state=$terraform_dir/terraform.tfstate -raw s3_bucket_name)
  api_url=$(terraform output \
    -state=$terraform_dir/terraform.tfstate -raw api_url)

  # deploy website frontend files
  ansible-playbook $ansible_deploy_path \
    -e "cloudfront_distribution_id=$cloudfront_distribution_id" \
    -e "project_base_dir=$project_base_dir" \
    -e "s3_bucket_name=$s3_bucket_name" \
    -e "api_url=$api_url"
fi
