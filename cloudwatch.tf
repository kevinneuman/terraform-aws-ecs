# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm
resource "aws_cloudwatch_metric_alarm" "example_api_cpu_alarm" {
  alarm_name          = "${var.project}-api-cpu-utilization-${var.env}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU utilization exceeds 80%"
  treat_missing_data  = "breaching"

  dimensions = {
    ClusterName = aws_ecs_cluster.example.name
    ServiceName = aws_ecs_service.example.name
  }

  alarm_actions = [] # e.g. SNS Topic ARN to send messages to a Slack channel with AWS Chatbot

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm
resource "aws_cloudwatch_metric_alarm" "example_api_memory_alarm" {
  alarm_name          = "${var.project}-api-memory-utilization-${var.env}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Memory utilization exceeds 80%"
  treat_missing_data  = "breaching"

  dimensions = {
    ClusterName = aws_ecs_cluster.example.name
    ServiceName = aws_ecs_service.example.name
  }

  alarm_actions = [] # e.g. SNS Topic ARN to send messages to a Slack channel with AWS Chatbot

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm
resource "aws_cloudwatch_metric_alarm" "example_api_running_task_count_alarm" {
  alarm_name          = "${var.project}-api-running-task-count-${var.env}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "SampleCount"
  threshold           = 1
  alarm_description   = "Running task count is less than 1"
  treat_missing_data  = "breaching"

  dimensions = {
    ClusterName = aws_ecs_cluster.example.name
    ServiceName = aws_ecs_service.example.name
  }

  alarm_actions = [] # e.g. SNS Topic ARN to send messages to a Slack channel with AWS Chatbot

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm
resource "aws_cloudwatch_metric_alarm" "example_api_gateway_4xx_alarm" {
  alarm_name          = "${var.project}-api-gateway-4xx-${var.env}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "4xx"
  namespace           = "AWS/ApiGateway"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "4xx errors exceeds 10"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ApiId = aws_apigatewayv2_api.example.id
  }

  alarm_actions = [] # e.g. SNS Topic ARN to send messages to a Slack channel with AWS Chatbot

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm
resource "aws_cloudwatch_metric_alarm" "example_api_gateway_5xx_alarm" {
  alarm_name          = "${var.project}-api-gateway-5xx-${var.env}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "5xx"
  namespace           = "AWS/ApiGateway"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "5xx errors exceeds 10"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ApiId = aws_apigatewayv2_api.example.id
  }

  alarm_actions = [] # e.g. SNS Topic ARN to send messages to a Slack channel with AWS Chatbot

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "example_ecs" {
  name              = aws_ecs_cluster.example.name
  retention_in_days = 30

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}
