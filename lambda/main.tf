data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_vpc_access_execution" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "archive_file" "notion_webhook" {
    type        = "zip"
  output_path = "${path.module}/notion_webhook_lambda/code.zip"
  source_dir  = "${path.module}/notion_webhook_lambda/code"
}

resource "aws_lambda_function" "notion_webhook" {
    function_name = "notion_webhook"
    filename = data.archive_file.notion_webhook.output_path
    source_code_hash = filebase64sha256(data.archive_file.notion_webhook.output_path)
    role = aws_iam_role.iam_for_lambda.arn
    handler = "notion_webhook.lambda_handler"
    runtime = "provided.al2023"
}
