variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "test-bucket"
  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "The bucket name must be between 3 and 63 characters long."
  }
}

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "test-function"
}

variable "handler" {
  description = "The handler for the Lambda function"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "runtime" {
  description = "The runtime for the Lambda function"
  type        = string
  default     = "python3.8"
}

variable "api_name" {
  description = "The name of the API Gateway"
  type        = string
  default     = "test-api"
}

variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "test-table"
  validation {
    condition     = length(var.table_name) >= 3 && length(var.table_name) <= 255
    error_message = "The table name must be between 3 and 255 characters long."
  }
}
