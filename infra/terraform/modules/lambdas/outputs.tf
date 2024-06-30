output "arns" {
  value = {
    for lambda_name in local.local.lambda_names : lambda_name => aws_lambda_function.lambdas[lambda_name].arn
  }
}
