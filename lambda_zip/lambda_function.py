import json
import boto3
import uuid
import os
import sys
from botocore.exceptions import ClientError

print("Lambda function code started")

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb', endpoint_url='http://localhost:4566')

def lambda_handler(event, context):
    print("Lambda handler started")
    print(f"Lambda function invoked with event: {json.dumps(event)}")
    try:
        # Parse the input
        path = event.get('path', '')
        body = json.loads(event.get('body', '{}'))
        
        print(f"Path: {path}")
        print(f"Body: {json.dumps(body)}")
        
        if path == '/add':
            return handle_add(body)
        elif path == '/save':
            return handle_save(body)
        else:
            raise ValueError(f"Unsupported path: {path}")
        
    except Exception as e:
        print(f"Error in lambda_handler: {str(e)}")
        print(f"Traceback: {sys.exc_info()[2]}")
        return {
            'statusCode': 400,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Content-Type': 'application/json'
            },
            'body': json.dumps({'error': str(e), 'saved': False})
        }

def handle_add(body):
    print("Handling add operation")
    number1 = float(body['number1'])
    number2 = float(body['number2'])
    
    result = add_numbers(number1, number2)
    print(f"Addition result: {result}")
    
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json'
        },
        'body': json.dumps({'result': result})
    }

def handle_save(body):
    print("Handling save operation")
    number1 = float(body['number1'])
    number2 = float(body['number2'])
    result = float(body['result'])
    
    saved = save_to_dynamodb(number1, number2, result)
    
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json'
        },
        'body': json.dumps({'saved': saved})
    }

def add_numbers(number1, number2):
    return number1 + number2

def save_to_dynamodb(number1, number2, result):
    try:
        table_name = os.environ.get('DYNAMODB_TABLE', 'test-table')
        print(f"Attempting to save to DynamoDB table: {table_name}")
        
        dynamodb_client = boto3.client('dynamodb', endpoint_url='http://localhost:4566')
        
        item = {
            'id': {'S': str(uuid.uuid4())},
            'number1': {'N': str(number1)},
            'number2': {'N': str(number2)},
            'result': {'N': str(result)}
        }
        print(f"Saving item: {json.dumps(item)}")
        
        response = dynamodb_client.put_item(TableName=table_name, Item=item)
        print(f"DynamoDB response: {json.dumps(response)}")
        
        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            print("Item successfully saved to DynamoDB")
            return True
        else:
            print(f"Failed to save item. Status code: {response['ResponseMetadata']['HTTPStatusCode']}")
            return False
    
    except Exception as e:
        print(f"Error saving to DynamoDB: {str(e)}")
        print(f"Error type: {type(e).__name__}")
        print(f"Error args: {e.args}")
        return False
