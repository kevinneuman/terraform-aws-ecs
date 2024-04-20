# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "example_secrets_manager" {
  name        = "${var.project}-secrets-manager-${var.env}"
  description = "The following IAM policy grants the required permissions for retrieving secrets from secrets manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          aws_secretsmanager_secret.example.arn
        ]
      }
    ]
  })

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "example_ecs_task_execution" {
  name        = "${var.project}-ecs-task-execution-${var.env}"
  description = "The task execution role grants the Amazon ECS container and Fargate agents permission to make AWS API calls on your behalf"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "example_ecs_task_execution_attach_AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.example_ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "example_ecs_task_execution_attach_secrets_manager" {
  role       = aws_iam_role.example_ecs_task_execution.name
  policy_arn = aws_iam_policy.example_secrets_manager.arn
}
