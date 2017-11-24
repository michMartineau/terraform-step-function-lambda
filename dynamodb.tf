resource "aws_dynamodb_table" "calculator-db" {
  name           = "tf-${terraform.workspace}-calculator_db"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "operator"
  attribute {
    name = "operator"
    type = "S"
  }
}