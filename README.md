# Simple Calculator with AWS Infrastructure

This project implements a simple calculator web application using AWS services, deployed and managed with Terraform and LocalStack for local development and testing.

## Project Overview

The application consists of:
- A frontend hosted on S3
- An API Gateway to handle requests
- A Lambda function for processing calculations and saving results
- A DynamoDB table for storing calculation results

## Prerequisites

- Terraform
- LocalStack
- AWS CLI (configured for LocalStack)
- Python 3.8+
- Node.js and npm (for frontend development)

## Project Structure

.
├── frontend/
│ ├── index.html
│ ├── script.js
│ └── styles.css
├── lambda_zip/
│ └── lambda_function.py
├── modules/
│ ├── api_gateway/
│ ├── dynamodb/
│ ├── lambda/
│ └── s3/
├── .gitignore
├── check_s3.py
├── main.tf
├── README.md
└── variables.tf

## Setup and Deployment

1. Start LocalStack:
   ```
   localstack start
   ```

2. Initialize Terraform:
   ```
   terraform init
   ```

3. Apply the Terraform configuration:
   ```
   terraform apply
   ```

## Usage

1. Open the S3 website URL in a web browser.
2. Enter two numbers and click "Add" to perform a calculation.
3. Click "Save Result" to store the calculation in DynamoDB.

## Development

- Modify the frontend files in the `frontend/` directory.
- Update the Lambda function in `lambda_zip/lambda_function.py`.
- Adjust the infrastructure by modifying the Terraform files in the root directory and the `modules/` subdirectories.

## Testing

- Use the `check_s3.py` script to verify S3 bucket configuration and contents.
- Test the API Gateway and Lambda function using tools like Postman or curl.
