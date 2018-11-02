variable "aws_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)."
  default = "us-east-1"
}

variable "scan_types" {
  type = "list"
  description = "The scan types that can be run."
}

variable "lambda_function_names" {
  type = "map"
  description = "The names to use for the Lambda functions.  The keys are the values in scan_types."
}

variable "lambda_function_zip_files" {
  type = "map"
  description = "The locations of the zip files for the Lambda functions.  The keys are the values in scan_types."
}

variable "tags" {
  type = "map"
  description = "Tags to apply to all AWS resources created"
  default = {}
}
