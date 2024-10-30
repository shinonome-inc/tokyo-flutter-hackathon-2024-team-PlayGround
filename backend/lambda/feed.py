import json
import datetime
from zoneinfo import ZoneInfo  
import boto3
import decimal


def update_character_level(user):
    # 必要経験値: 2^n * 10（nは現在のレベル）
    total_xp = user.get('characterExperience', 0)
    level = 1
    cumulative_xp = 0

    while True:
        required_xp = 10 * (2 ** level) 
        cumulative_xp += required_xp 

        if total_xp >= cumulative_xp: 
            level += 1
        else:
            break

    user['characterLevel'] = level
    return level

def lambda_handler(event, context):
    # DynamoDBリソースの取得
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('Users')

    # LambdaAuthorizerから渡されたユーザーID
    user_id = event['requestContext']['authorizer']['userId']

    # Authorizationトークンを取得
    authorization_token = event['headers'].get('Authorization')

    # DynamoDBからユーザー情報を取得
    try:
        response = table.get_item(
            Key={
                'userId': user_id
            }
        )
        user = response.get('Item')
        if not user:
            return {
                'statusCode': 404,
                'body': json.dumps('ユーザーが見つかりません。')
            }
        
        # 数値フィールドを int に変換
        user['characterLevel'] = int(user.get('characterLevel', 1))
        user['characterExperience'] = int(user.get('characterExperience', 0))
        user['feedCount'] = int(user.get('feedCount', 0))
        user['feededCount'] = int(user.get('feededCount', 0))
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'DynamoDBからのユーザー情報取得時にエラーが発生しました: {str(e)}')
        }
    
    # JSTの現在時刻を取得
    japan_time = datetime.datetime.now(ZoneInfo('Asia/Tokyo')) 
    current_date = japan_time.strftime('%Y-%m-%d')
    
    # 日付が変わった場合、feededCountをリセット
    if user.get('lastFeedDate') != current_date:
        user['feededCount'] = 0
        user['lastFeedDate'] = current_date
    
    # 1日の最大餌やり回数
    feed_count = user.get('feedCount', 0)

    # 餌やり可能かを判定
    if user.get('feededCount', 0) < feed_count:
        # 経験値と餌やりカウントを更新
        user['feededCount'] += 1
        user['characterExperience'] = user.get('characterExperience', 0) + 10
        

        # レベルアップの判定と更新
        new_level = update_character_level(user)
        
        # DynamoDBにユーザー情報を更新
        try:
            table.put_item(Item=user)
        except Exception as e:
            return {
                'statusCode': 500,
                'body': json.dumps(f'DynamoDBへのユーザー情報更新時にエラーが発生しました: {str(e)}')
            }

        return {
            'statusCode': 200,
            'body': json.dumps({
                'characterLevel': new_level,
                'currentExperience': user['characterExperience'],
                'feedCount': feed_count - user['feededCount'],
            })
        }

    else:
        return {
            'statusCode': 400,
            'body': json.dumps('本日の餌やり回数が上限に達しました。')
        }
