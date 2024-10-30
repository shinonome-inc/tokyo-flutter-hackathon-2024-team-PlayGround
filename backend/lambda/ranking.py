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
            Limit=100 
        )
        
        items = response.get('Items', [])
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps(items, default=decimal_default)
        }
    
    except Exception as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Internal Server Error'})
        }
    
