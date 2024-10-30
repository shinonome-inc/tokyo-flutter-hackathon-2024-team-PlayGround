import json
import boto3

def lambda_handler(event, context):
    print(event)
    # LambdaAuthorizerから渡されたユーザーID
    user_id = event['requestContext']['authorizer']['userId']