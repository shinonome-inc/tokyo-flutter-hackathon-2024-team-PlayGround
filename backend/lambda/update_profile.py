import json
import boto3
import decimal

# DynamoDBリソースの取得
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users')

def lambda_handler(event, context):
    # LambdaAuthorizerから渡されたユーザーID
    user_id = event['requestContext']['authorizer']['userId']
    
    # eventからcharacterNameを取得
    body = json.loads(event['body'])
    character_name = body['characterName']

    if not character_name:
            return {
                'statusCode': 400,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({'message': 'characterName is required'})
            }
    
    try:
        # DynamoDBのアイテム更新
        response = table.update_item(
            Key={'userId': user_id},
            UpdateExpression="SET characterName = :c",
            ExpressionAttributeValues={
                ':c': character_name
            },
            ReturnValues="UPDATED_NEW"
        )

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'  
            },
            'body': json.dumps({
                'updatedAttributes': response.get('Attributes', {})
            })
        }
    
    except Exception as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Internal Server Error'})
        }
