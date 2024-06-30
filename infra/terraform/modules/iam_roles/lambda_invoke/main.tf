data "aws_iam_policy_document" "lambda_invoke_policy" {
  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_invoke" {
  name   = local.rule_policy_name
  policy = data.aws_iam_policy_document.lambda_invoke_policy.json
}

data "aws_iam_policy_document" "lambda_invoke_role" {
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

resource "aws_iam_role" "lambda_invoke" {
  name               = local.rule_policy_name
  assume_role_policy = data.aws_iam_policy_document.lambda_invoke_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_invoke" {
  role       = aws_iam_role.lambda_invoke.name
  policy_arn = aws_iam_policy.lambda_invoke.arn
}
