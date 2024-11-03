import json
import boto3
import decimal

# DynamoDBからユーザー情報を取得
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users')

# Decimal を JSON シリアライズ可能にするためのヘルパークラス
class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, decimal.Decimal):
            return int(obj)  
        return super(DecimalEncoder, self).default(obj)

def lambda_handler(event, context):
    # LambdaAuthorizerから渡されたユーザーID
    user_id = event['requestContext']['authorizer']['userId']

    # 取得したい属性を指定
    attributes_to_get = 'userName, avatarUrl, characterName, characterLevel, characterExperience, characterBackground, characterClothes, feedCount'

    try:
        response = table.get_item(
            Key={
                'userId': user_id 
            },
            ProjectionExpression=attributes_to_get,
        )

        item = response.get('Item')

        if not item:
            return {
                'statusCode': 404,
                'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',  
                'Access-Control-Allow-Headers': 'Content-Type, Authorization',  
                'Access-Control-Allow-Methods': 'OPTIONS,GET'  
            },
                'body': json.dumps({'error': 'User data not found'})
            }

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',  
                'Access-Control-Allow-Headers': 'Content-Type, Authorization',  
                'Access-Control-Allow-Methods': 'OPTIONS,GET',
                'Access-Control-Expose-Headers': 'Authorization, X-Custom-Header'  
            },
            'body': json.dumps(item, cls=DecimalEncoder)
    }

    except Exception as e:
        print(f"Error retrieving data: {e}")
        return {
                'statusCode': 500,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
                    'Access-Control-Allow-Methods': 'OPTIONS,GET'
            },
                'body': "Internal Server Error"
            }
