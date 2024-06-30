data "aws_iam_policy_document" "dynamodb_full_access_policy" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "dynamodb_full_access" {
  name   = local.rule_policy_name
  policy = data.aws_iam_policy_document.dynamodb_full_access_policy.json
}

data "aws_iam_policy_document" "dynamodb_full_access_role" {
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

resource "aws_iam_role" "dynamodb_full_access" {
  name               = local.rule_policy_name
  assume_role_policy = data.aws_iam_policy_document.dynamodb_full_access_role.json
}

resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
  role       = aws_iam_role.dynamodb_full_access.name
  policy_arn = aws_iam_policy.dynamodb_full_access.arn
}
