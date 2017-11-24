resource "aws_cloudwatch_log_group" "calculator-log-group" {
  name    = "/aws/lambda/${aws_lambda_function.addition.function_name}"
  retention_in_days = "1"
}

resource "aws_cloudwatch_event_rule" "calculator" {
  name = "calculator"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "health_monitor_event_target" {
  rule = "${aws_cloudwatch_event_rule.calculator.id}"
  arn = "${aws_sfn_state_machine.calculator-state-machine.id}"
  role_arn = "${aws_iam_role.iam_for_sfn.arn}"
  input = <<EOF
  {
  "operand1": "3",
  "operand2": "5",
  "operator": "add"
  }
EOF
}