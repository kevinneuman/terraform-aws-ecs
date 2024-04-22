# terraform-aws-ecs

An AWS infrastructure deployment example using Terraform. Excludes load balancers and auto-scaling for ECS, and does not deploy RDS in Multi-AZ to keep costs down.

## Usage

Configure the AWS CLI with your credentials.

The `terraform init` command initializes a working directory containing Terraform configuration files.

```
terraform init
```

The `terraform plan` command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.

```
terraform plan
```

The `terraform apply` command executes the actions proposed in a Terraform plan.

```
terraform apply
```

The `terraform destroy` command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.

```
terraform destroy
```

## AWS Infrastructure

![AWS Infrastructure](https://github.com/kevinneuman/terraform-aws-ecs/assets/17978140/571209f5-db29-4933-8b30-098a7f8e09e4)
