# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret
resource "aws_secretsmanager_secret" "example" {
  name                    = local.project_name
  recovery_window_in_days = 0

  depends_on = [
    aws_db_instance.example
  ]

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version
resource "aws_secretsmanager_secret_version" "example" {
  secret_id = aws_secretsmanager_secret.example.id

  secret_string = jsonencode({
    database_url = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.example.address}:${var.db_port}/${var.db_name}?schema=${var.db_schema}"
  })
}
