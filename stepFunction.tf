resource "aws_sfn_state_machine" "calculator-state-machine" {
  name     = "tf-${terraform.workspace}-calculator-state-machine"
  role_arn = "${aws_iam_role.iam_for_sfn.arn}"

  definition = <<EOF
{
  "Comment": "An example of the Amazon States Language using an AWS Lambda Functions",
  "StartAt": "FetchAndCheck",
  "States": {
    "FetchAndCheck": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.fetchAndCheck.arn}",
      "Next": "ChoiceStateX",
      "Catch": [
            {
               "ErrorEquals": ["InvalidInputError", "InvalidOperandError"],
               "Next": "FailState"
            }
         ]
    },
    "ChoiceStateX": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.op",
          "StringEquals": "add",
          "Next": "Addition"
        },
        {
          "Variable": "$.op",
          "StringEquals": "sub",
          "Next": "Subtraction"
        },
        {
          "Variable": "$.op",
          "StringEquals": "mul",
          "Next": "Multiplication"
        },
        {
          "Variable": "$.op",
          "StringEquals": "div",
          "Next": "Division"
        }
      ],
      "Default": "DefaultState"
    },

    "Addition": {
      "Type" : "Task",
      "Resource": "${aws_lambda_function.addition.arn}",
      "Next": "InsertInDB"
    },

    "Subtraction": {
      "Type" : "Task",
      "Resource": "${aws_lambda_function.subtraction.arn}",
      "Next": "InsertInDB"
    },

    "Multiplication": {
      "Type" : "Task",
      "Resource": "${aws_lambda_function.multiplication.arn}",
      "Next": "InsertInDB"
    },

    "Division": {
      "Type" : "Task",
      "Resource": "${aws_lambda_function.division.arn}",
      "Next": "InsertInDB",
      "Catch": [
            {
               "ErrorEquals": ["ZeroDivisorError"],
               "Next": "FailState"
            }
         ]
    },

    "DefaultState": {
      "Type": "Pass",
      "Next": "FailState"
    },

    "InsertInDB": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.insertInDB.arn}",
      "Next": "SuccessState",
      "Catch": [
            {
               "ErrorEquals": ["States.ALL"],
               "Next": "FailState"
            }
         ]
    },

    "FailState": {
      "Type": "Fail"
    },

    "SuccessState": {
      "Type": "Succeed"
    }
  }
}
EOF
}