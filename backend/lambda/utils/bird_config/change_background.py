import json
import boto3

# DynamoDBリソースの取得
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users')

def lambda_handler(event, context):
    print(event)
    # LambdaAuthorizerから渡されたユーザーID
    user_id = event['requestContext']['authorizer']['userId']

    # eventからcharacterNameを取得
    body = json.loads(event['body'])
    background = body['item']

    if not background:
            return {
                'statusCode': 400,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({'message': 'item is required'})
            }
    
    try:
        # DynamoDBのアイテム更新
        response = table.update_item(
            Key={'userId': user_id},
            UpdateExpression="SET characterBackground = :c",
            ExpressionAttributeValues={
                ':c': background
            },
            ReturnValues="UPDATED_NEW"
        )

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'  
            },
            'body': json.dumps(
                response.get('Attributes', {}), ensure_ascii=False
            )
        }
    
    except Exception as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Internal Server Error'})
        }