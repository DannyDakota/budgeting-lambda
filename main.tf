terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
      }
    }
}

provider "aws" {
    region = var.AWS_REGION
}

module "api_gateway" {
    source = "./gateway"
    notion_webhook_arn = module.lambda.notion_webhook_arn
}

module "lambda" {
    source = "./lambda"
}