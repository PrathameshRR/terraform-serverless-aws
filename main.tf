provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    s3             = "http://localhost:4566"
    sts            = "http://localhost:4566"
    iam            = "http://localhost:4566"
  }
}

module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
}

module "lambda" {
  source = "./modules/lambda"
  function_name = var.function_name
  table_name = var.table_name
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  api_name             = var.api_name
  lambda_arn           = module.lambda.lambda_arn
  lambda_function_name = var.function_name
}

module "dynamodb" {
  source = "./modules/dynamodb"
  table_name = var.table_name
}

output "api_endpoint" {
  description = "Base URL for API Gateway stage"
  value       = module.api_gateway.api_endpoint
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda.function_name
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = module.dynamodb.table_name
}

output "s3_website_endpoint" {
  description = "S3 static website endpoint"
  value       = module.s3.bucket_website_endpoint
}

output "s3_website_url" {
  description = "S3 static website URL"
  value       = "http://${module.s3.bucket_website_endpoint}"
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3.bucket_name
}
