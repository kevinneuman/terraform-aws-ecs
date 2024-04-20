# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_snapshot
data "aws_db_snapshot" "example" {
  db_instance_identifier = local.project_name
  most_recent            = true
  count                  = can(data.aws_db_snapshot.example[0].id) ? 1 : 0
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "example" {
  identifier                = local.project_name
  engine                    = "postgres"
  engine_version            = "16.1"
  port                      = var.db_port
  db_name                   = var.db_name
  username                  = var.db_username
  password                  = var.db_password
  instance_class            = "db.t4g.micro"
  allocated_storage         = 20
  skip_final_snapshot       = true # Set to false to enable snapshot creation upon destruction
  final_snapshot_identifier = "${local.project_name}-${formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())}"
  snapshot_identifier       = length(data.aws_db_snapshot.example) > 0 ? data.aws_db_snapshot.example[0].id : null
  backup_retention_period   = 0
  multi_az                  = false
  db_subnet_group_name      = aws_db_subnet_group.example_public.id
  vpc_security_group_ids    = [aws_security_group.example_postgres.id]
  publicly_accessible       = false

  lifecycle {
    ignore_changes = [
      final_snapshot_identifier,
      snapshot_identifier
    ]
  }

  tags = {
    Name        = local.project_name
    Environment = var.env
  }
}
