locals {
  project_name = "${var.project}-${var.env}"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api
resource "aws_apigatewayv2_api" "example" {
  name                         = local.project_name
  protocol_type                = "HTTP"
  disable_execute_api_endpoint = false # change to true to use only domain name with aws_apigatewayv2_domain_name

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage
resource "aws_apigatewayv2_stage" "example" {
  api_id      = aws_apigatewayv2_api.example.id
  name        = "$default"
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = 5000
    throttling_rate_limit  = 10000
  }

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_vpc_link
resource "aws_apigatewayv2_vpc_link" "example" {
  name               = local.project_name
  security_group_ids = [aws_security_group.example_vpc_link.id]
  subnet_ids         = [aws_subnet.example_public_1.id, aws_subnet.example_public_2.id, aws_subnet.example_public_3.id]

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/service_discovery_service
data "aws_service_discovery_service" "example" {
  name         = local.project_name
  namespace_id = aws_service_discovery_http_namespace.example.id

  depends_on = [
    aws_service_discovery_http_namespace.example,
    aws_ecs_service.example
  ]

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration
resource "aws_apigatewayv2_integration" "example" {
  api_id             = aws_apigatewayv2_api.example.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = data.aws_service_discovery_service.example.arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.example.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route
resource "aws_apigatewayv2_route" "example" {
  api_id    = aws_apigatewayv2_api.example.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.example.id}"
}
