resource "aws_apigatewayv2_api" "api_gateway" {
    name = "api_gateway"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda_stage" {
    api_id = aws_apigatewayv2_api.api_gateway.id

    name = "lambda_stage"
    auto_deploy = true
}

resource "aws_apigatewayv2_integration" "notion_webhook" {
    api_id = aws_apigatewayv2_api.api_gateway.id

    integration_uri = var.notion_webhook_arn
    integration_type = "AWS_PROXY"
    integration_method = "POST"
}

resource "aws_apigatewayv2_route" "post_to_notion" {
    api_id = aws_apigatewayv2_api.api_gateway.id

    route_key = "POST /notion"
    target = "integrations/${aws_apigatewayv2_integration.notion_webhook.id}"
}