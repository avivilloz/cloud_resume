# -----------------------------------------------------------------------------
# LAMBDA_DYNAMODB_FULL_ACCESS

data "aws_iam_policy_document" "lambda_dynamodb_full_access_policy" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_dynamodb_full_access" {
  name   = "lambda_dynamodb_full_access"
  policy = data.aws_iam_policy_document.lambda_dynamodb_full_access_policy.json
}

data "aws_iam_policy_document" "lambda_dynamodb_full_access_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "apigateway.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "lambda_dynamodb_full_access" {
  name               = "lambda_dynamodb_full_access"
  assume_role_policy = data.aws_iam_policy_document.lambda_dynamodb_full_access_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_full_access" {
  role       = aws_iam_role.lambda_dynamodb_full_access.name
  policy_arn = aws_iam_policy.lambda_dynamodb_full_access.arn
}

# -----------------------------------------------------------------------------
# API_GATEWAY_LAMBDA_INVOKE

data "aws_iam_policy_document" "api_gateway_lambda_invoke_policy" {
  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "api_gateway_lambda_invoke" {
  name   = "api_gateway_lambda_invoke"
  policy = data.aws_iam_policy_document.api_gateway_lambda_invoke_policy.json
}

data "aws_iam_policy_document" "api_gateway_lambda_invoke_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "apigateway.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "api_gateway_lambda_invoke" {
  name               = "api_gateway_lambda_invoke"
  assume_role_policy = data.aws_iam_policy_document.api_gateway_lambda_invoke_role.json
}

resource "aws_iam_role_policy_attachment" "api_gateway_lambda_invoke" {
  role       = aws_iam_role.api_gateway_lambda_invoke.name
  policy_arn = aws_iam_policy.api_gateway_lambda_invoke.arn
}
