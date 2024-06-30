resource "aws_dynamodb_table" "views_count" {
  name         = local.views_count_table_name
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "N"
  }
}

