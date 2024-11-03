import json
import boto3
from decimal import Decimal

# DynamoDBリソース
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users')

# Decimalをintに変換する関数
def decimal_default(obj):
    if isinstance(obj, Decimal):
        return int(obj)
    raise TypeError

def lambda_handler(event, context):
    try:
        # ランキング取得用のクエリ
        response = table.query(
            IndexName='RankIndex',
            KeyConditionExpression=boto3.dynamodb.conditions.Key('gsiPk').eq('RANK'),
            ScanIndexForward=False,  # 降順
            Limit=100, 
            ProjectionExpression='userName, avatarUrl, characterName, characterLevel, characterBackground, characterClothes'
        )
        
        items = response.get('Items', [])
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type, Authorization',
                'Access-Control-Allow-Methods': 'OPTIONS,GET',
                'Access-Control-Expose-Headers': 'Authorization, X-Custom-Header' 
            },
            'body': json.dumps(items, default=decimal_default)
        }
    
    except Exception as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type, Authorization',
                'Access-Control-Allow-Methods': 'OPTIONS,GET'
            },
            'body': json.dumps({'message': 'Internal Server Error'})
        }
    
