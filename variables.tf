variable "aws_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)."
  default = "us-east-1"
}

variable "trustymail_lambda_function_name" {
  type = "string"
  description = "The name to use for the trustymail Lambda function"
}

variable "trustymail_lambda_function_zip_file" {
  type = "string"
  description = "The location of the zip file for the trustymail Lambda function"
}

variable "sslyze_lambda_function_name" {
  type = "string"
  description = "The name to use for the sslyze Lambda function"
}

variable "sslyze_lambda_function_zip_file" {
  type = "string"
  description = "The location of the zip file for the sslyze Lambda function"
}

variable "tags" {
  type = "map"
  default = {}
  description = "Tags to apply to all AWS resources created"
}
