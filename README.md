# terraform-aws-ecs

An AWS infrastructure deployment example using Terraform. Excludes load balancers and auto-scaling for ECS, and does not deploy RDS in Multi-AZ to keep costs down.

## Usage

Configure the AWS CLI with your credentials and run:

```
terraform plan
```

and

```
terraform apply
```

to destroy everything, run:

```
terraform destroy
```

## AWS Infrastructure

![AWS Infrastructure](https://github.com/kevinneuman/terraform-aws-ecs/assets/17978140/571209f5-db29-4933-8b30-098a7f8e09e4)
