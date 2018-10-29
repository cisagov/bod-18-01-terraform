# IAM assume role policy document for the role we're creating for the
# lambda function
data "aws_iam_policy_document" "assume_role_doc" {
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
resource "aws_iam_role" "role" {
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_doc.json}"
}

# IAM policy document that that allows some Cloudwatch permissions for
# our Lambda function.  This will allow the Lambda function to
# generate log output in Cloudwatch.  This will be applied to the role
# we are creating.
data "aws_iam_policy_document" "cloudwatch_doc" {
  statement {
    effect = "Allow"
    
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.logs.arn}",
    ]
  }
}

# The CloudWatch policy for our role
resource "aws_iam_role_policy" "cloudwatch_policy" {
  role = "${aws_iam_role.role.id}"
  policy = "${data.aws_iam_policy_document.cloudwatch_doc.json}"
}

# The AWS Lambda function that performs trustymail scans
resource "aws_lambda_function" "lambda" {
  filename = "${var.lambda_function_zip_file}"
  source_code_hash = "${base64sha256(file(var.lambda_function_zip_file))}"
  function_name = "${var.lambda_function_name}"
  role = "${aws_iam_role.role.arn}"
  handler = "lambda_handler.handler"
  runtime = "python3.6"
  timeout = 300
  memory_size = 128
  description = "Lambda function for performing Trustworthy Email scans"

  tags = "${var.tags}"
}

# The Cloudwatch log group for the Lambda function
resource "aws_cloudwatch_log_group" "logs" {
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = 30

  tags = "${var.tags}"
}
