# IAM assume role policy document for the role we're creating for the
# lambda function
data "aws_iam_policy_document" "trustymail_assume_role_doc" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# The role we're creating for the lambda function
resource "aws_iam_role" "trustymail_role" {
  assume_role_policy = "${data.aws_iam_policy_document.trustymail_assume_role_doc.json}"
}

# IAM policy document that that allows some Cloudwatch permissions for
# our Lambda function.  This will allow the Lambda function to
# generate log output in Cloudwatch.  This will be applied to the role
# we are creating.
data "aws_iam_policy_document" "trustymail_cloudwatch_doc" {
  statement {
    effect = "Allow"
    
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.trustymail_logs.arn}",
    ]
  }
}

# The CloudWatch policy for our role
resource "aws_iam_role_policy" "trustymail_cloudwatch_policy" {
  role = "${aws_iam_role.trustymail_role.id}"
  policy = "${data.aws_iam_policy_document.trustymail_cloudwatch_doc.json}"
}

# The AWS Lambda function that performs trustymail scans
resource "aws_lambda_function" "trustymail_lambda" {
  filename = "${var.trustymail_lambda_function_zip_file}"
  source_code_hash = "${base64sha256(file(var.trustymail_lambda_function_zip_file))}"
  function_name = "${var.trustymail_lambda_function_name}"
  role = "${aws_iam_role.trustymail_role.arn}"
  handler = "lambda_handler.handler"
  runtime = "python3.6"
  timeout = 300
  memory_size = 128
  description = "Lambda function for performing Trustworthy Email scans"

  tags = "${var.tags}"
}

# The Cloudwatch log group for the Lambda function
resource "aws_cloudwatch_log_group" "trustymail_logs" {
  name = "/aws/lambda/${aws_lambda_function.trustymail_lambda.function_name}"
  retention_in_days = 30

  tags = "${var.tags}"
}
