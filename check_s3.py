import boto3
import json

# Set up a boto3 session with dummy credentials for LocalStack
session = boto3.Session(
    aws_access_key_id='test',
    aws_secret_access_key='test',
    region_name='us-east-1'
)

# Create an S3 client using the session and LocalStack endpoint
s3 = session.client('s3', endpoint_url='http://localhost:4566')

bucket_name = 'test-bucket'

# List all buckets
try:
    response = s3.list_buckets()
    print("Existing buckets:")
    for bucket in response['Buckets']:
        print(f"  {bucket['Name']}")
except Exception as e:
    print(f"Error listing buckets: {e}")

# Try to get website configuration
try:
    website = s3.get_bucket_website(Bucket=bucket_name)
    print(f"\nWebsite configuration for {bucket_name}:")
    print(json.dumps(website, indent=2))
except s3.exceptions.ClientError as e:
    print(f"\nError getting website configuration for {bucket_name}: {e}")

# List bucket contents
try:
    objects = s3.list_objects_v2(Bucket=bucket_name)
    print(f"\nContents of {bucket_name}:")
    for obj in objects.get('Contents', []):
        print(f"  {obj['Key']}")
except s3.exceptions.ClientError as e:
    print(f"Error listing objects in {bucket_name}: {e}")

# Get bucket policy
try:
    policy = s3.get_bucket_policy(Bucket=bucket_name)
    print(f"\nBucket policy for {bucket_name}:")
    print(json.dumps(json.loads(policy['Policy']), indent=2))
except s3.exceptions.ClientError as e:
    print(f"\nError getting bucket policy for {bucket_name}: {e}")

# Get bucket ACL
try:
    acl = s3.get_bucket_acl(Bucket=bucket_name)
    print(f"\nBucket ACL for {bucket_name}:")
    print(json.dumps(acl, indent=2))
except s3.exceptions.ClientError as e:
    print(f"\nError getting bucket ACL for {bucket_name}: {e}")
