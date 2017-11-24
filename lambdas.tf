
data "archive_file" "lambdas" {
  type        = "zip"
  source_dir  = "lambdas"
  output_path = "lambdas.zip"
}

resource "aws_lambda_function" "addition" {
  filename         = "lambdas.zip"
  function_name    = "tf-${terraform.workspace}-addition"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "addition.handler"
  source_code_hash = "${base64sha256(file("lambdas.zip"))}"
  runtime          = "nodejs6.10"
  depends_on = ["data.archive_file.lambdas"]
}

resource "aws_lambda_function" "division" {
  filename         = "lambdas.zip"
  function_name    = "tf-${terraform.workspace}-division"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "division.handler"
  source_code_hash = "${base64sha256(file("lambdas.zip"))}"
  runtime          = "nodejs6.10"

  depends_on = ["data.archive_file.lambdas"]
}

resource "aws_lambda_function" "fetchAndCheck" {
  filename         = "lambdas.zip"
  function_name    = "tf-${terraform.workspace}-fetchAndCheck"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "fetchAndCheck.handler"
  source_code_hash = "${base64sha256(file("lambdas.zip"))}"
  runtime          = "nodejs6.10"

  depends_on = ["data.archive_file.lambdas"]
}

resource "aws_lambda_function" "insertInDB" {
  filename         = "lambdas.zip"
  function_name    = "tf-${terraform.workspace}-insertInDB"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "insertInDB.handler"
  source_code_hash = "${base64sha256(file("lambdas.zip"))}"
  runtime          = "nodejs6.10"

  environment {
    variables = {
      TABLE_NAME = "${aws_dynamodb_table.calculator-db.name}"
    }
  }

  depends_on = ["aws_dynamodb_table.calculator-db","data.archive_file.lambdas"]
}

resource "aws_lambda_function" "multiplication" {
  filename         = "lambdas.zip"
  function_name    = "tf-${terraform.workspace}-multiplication"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "multiplication.handler"
  source_code_hash = "${base64sha256(file("lambdas.zip"))}"
  runtime          = "nodejs6.10"
  depends_on = ["data.archive_file.lambdas"]
}

resource "aws_lambda_function" "subtraction" {
  filename         = "lambdas.zip"
  function_name    = "tf-${terraform.workspace}-subtraction"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "subtraction.handler"
  source_code_hash = "${base64sha256(file("lambdas.zip"))}"
  runtime          = "nodejs6.10"

  depends_on = ["data.archive_file.lambdas"]
}