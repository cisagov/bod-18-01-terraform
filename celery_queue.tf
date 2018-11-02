# This is the SQS queue where tasks will be sent via celery for
# workers to process
resource "aws_sqs_queue" "bod_1801_celery" {
  name = "bod_1801_celery"
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 20

  redrive_policy = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.bod_1801_celery_dead_letter.arn}\",\"maxReceiveCount\":4}"

  tags = "${var.tags}"
}

# This is the dead-letter queue for the previous SQS queue
resource "aws_sqs_queue" "bod_1801_celery_dead_letter" {
  name = "bod_1801_celery_dead_letter"
  message_retention_seconds = 1209600

  tags = "${var.tags}"
}
