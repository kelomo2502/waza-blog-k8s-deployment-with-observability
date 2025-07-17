# terraform {
#   backend "s3" {
#     bucket         = "waza-terraform-state"
#     key            = "eks/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "waza-terraform-lock"
#     encrypt        = true
#   }
# }
