# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
resource "aws_ecs_cluster" "example" {
  name = local.project_name

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "example" {
  family                   = local.project_name
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.example_ecs_task_execution.arn
  task_role_arn            = aws_iam_role.example_ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = local.project_name
      image     = "public.ecr.aws/ecs-sample-image/amazon-ecs-sample:latest"
      cpu       = 256
      memory    = 512
      essential = true
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost/ || exit 1"],
        startPeriod = 30
        interval    = 30
        retries     = 3
        timeout     = 5
      }
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
          protocol      = "tcp"
          name          = local.project_name # needed for service connect
          appProtocol   = "http"             # needed for service connect
        }
      ]
      logConfiguration = {
        "logDriver" : "awslogs"
        "options" : {
          "awslogs-region" : var.region,
          "awslogs-group" : aws_cloudwatch_log_group.example_ecs.name,
          "awslogs-stream-prefix" : local.project_name
        }
      }
      secrets = [
        {
          "name" : "DATABASE_URL",
          "valueFrom" : "${aws_secretsmanager_secret.example.arn}:database_url::"
        }
      ]
      environment = [
        {
          "name" : "PORT",
          "value" : tostring(var.app_port)
        }
      ]
    }
  ])

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_http_namespace
resource "aws_service_discovery_http_namespace" "example" {
  name = local.project_name

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_service" "example" {
  name                               = local.project_name
  cluster                            = aws_ecs_cluster.example.id
  task_definition                    = aws_ecs_task_definition.example.arn
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"

  network_configuration {
    assign_public_ip = true
    subnets          = [aws_subnet.example_public_1.id, aws_subnet.example_public_2.id, aws_subnet.example_public_3.id]
    security_groups  = [aws_security_group.example_api.id]
  }

  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.example.arn

    service {
      discovery_name = local.project_name
      port_name      = local.project_name

      client_alias {
        dns_name = local.project_name
        port     = var.app_port
      }
    }
  }

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}
