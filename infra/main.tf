#Provider start----------------------------------------------------------------#
terraform {
    backend "s3" {
      bucket = "djh-terraform-course"
      key = "lambda_notification_terraform.tfstate"
      region = "us-east-1"
      dynamodb_table = "cloudcast-terraform-course"
    }
}

provider "aws" {
  profile = "cloud-notification"
  region = "us-east-1"
}
#Provider end----------------------------------------------------------------#
#Lambda start----------------------------------------------------------------#
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../function/lambda.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "cloud_notification"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.test"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.11"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
#Lambda end----------------------------------------------------------------#
#Policy start----------------------------------------------------------------#
resource "aws_iam_policy" "lamda_policy" {
  name        = "notification_policy"
  path        = "/"
  description = "My Lambda Notification Policy"

  # Terraform expression result to valid JSON syntax.
  policy = data.aws_iam_policy_document.notification_policy.json
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.iam_for_lambda.name
 policy_arn  = aws_iam_policy.lamda_policy.arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "notification_policy" {
  statement {
    sid       = "VisualEditor0"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "dynamodb:DescribeImport",
      "dynamodb:BatchWriteItem",
      "dynamodb:ListTables",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateGlobalTable",
      "dynamodb:UpdateItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:DescribeExport",
      "dynamodb:ListImports",
      "dynamodb:DescribeEndpoints",
      "dynamodb:ListExports",
      "dynamodb:UpdateTable",
      "dynamodb:GetRecords",
      "iam:PassRole",
      "sns:GetTopicAttributes",
      "sns:CreateTopic",
      "sns:ListTopics",
      "sns:Unsubscribe",
      "sns:GetSubscriptionAttributes",
      "sns:ListSubscriptions",
      "sns:OptInPhoneNumber",
      "sns:SetEndpointAttributes",
      "sns:ListPhoneNumbersOptedOut",
      "sns:GetEndpointAttributes",
      "sns:SetSubscriptionAttributes",
      "sns:Publish",
      "sns:GetSMSSandboxAccountStatus",
      "sns:Subscribe",
      "sns:ConfirmSubscription",
      "sns:GetSMSAttributes",
    ]
  }
}
#Policy end----------------------------------------------------------------#