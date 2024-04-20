variable "env" {
  type        = string
  description = "dev/prod"
  default     = "dev"
}

variable "aws_account_id" {
  type        = string
  description = "Eg. 123456789012"
  default     = "account id here"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "example"
}

variable "app_port" {
  type        = number
  description = "Application port"
  default     = 80
}

variable "db_username" {
  type        = string
  description = "AWS RDS PostgreSQL username"
  default     = "admin_user"
}

variable "db_password" {
  type        = string
  description = "AWS RDS PostgreSQL password"
  default     = "StrongPassword!234"
}

variable "db_port" {
  type        = number
  description = "AWS RDS PostgreSQL port"
  default     = 5678
}

variable "db_name" {
  type        = string
  description = "AWS RDS PostgreSQL database name"
  default     = "example"
}

variable "db_schema" {
  type        = string
  description = "AWS RDS PostgreSQL database schema"
  default     = "app"
}
