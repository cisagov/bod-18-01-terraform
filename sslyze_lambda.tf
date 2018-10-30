# IAM assume role policy document for the role we're creating for the
# lambda function
data "aws_iam_policy_document" "sslyze_assume_role_doc" {
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
resource "aws_iam_role" "sslyze_role" {
  assume_role_policy = "${data.aws_iam_policy_document.sslyze_assume_role_doc.json}"
}

# IAM policy document that that allows some Cloudwatch permissions for
# our Lambda function.  This will allow the Lambda function to
# generate log output in Cloudwatch.  This will be applied to the role
# we are creating.
data "aws_iam_policy_document" "sslyze_cloudwatch_doc" {
  statement {
    effect = "Allow"
    
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.sslyze_logs.arn}",
    ]
  }
}

# The CloudWatch policy for our role
resource "aws_iam_role_policy" "sslyze_cloudwatch_policy" {
  role = "${aws_iam_role.sslyze_role.id}"
  policy = "${data.aws_iam_policy_document.sslyze_cloudwatch_doc.json}"
}

# The AWS Lambda function that performs sslyze scans
resource "aws_lambda_function" "sslyze_lambda" {
  filename = "${var.sslyze_lambda_function_zip_file}"
  source_code_hash = "${base64sha256(file(var.sslyze_lambda_function_zip_file))}"
  function_name = "${var.sslyze_lambda_function_name}"
  role = "${aws_iam_role.sslyze_role.arn}"
  handler = "lambda_handler.handler"
  runtime = "python3.6"
  timeout = 300
  memory_size = 128
  description = "Lambda function for performing sslyze scans"

  tags = "${var.tags}"
}

# The Cloudwatch log group for the Lambda function
resource "aws_cloudwatch_log_group" "sslyze_logs" {
  name = "/aws/lambda/${aws_lambda_function.sslyze_lambda.function_name}"
  retention_in_days = 30

  tags = "${var.tags}"
}
