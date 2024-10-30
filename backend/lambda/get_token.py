import json
import urllib.parse
import urllib.request
import os
import boto3
import datetime
from zoneinfo import ZoneInfo

# Lambdaの環境変数からGitHub OAuthのクライアントIDとクライアントシークレットを取得
GITHUB_CLIENT_ID = os.environ['GITHUB_CLIENT_ID']
GITHUB_CLIENT_SECRET = os.environ['GITHUB_CLIENT_SECRET']

# DynamoDBにユーザー情報を保存
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users') 

def lambda_handler(event, context):
    # API Gateway経由で受け取るGitHub認証コード
    print(event)
    code = event.get('queryStringParameters', {}).get('code')

    if not code:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'GitHub authorization code not provided.'})
        }

    # GitHubからアクセストークンを取得するためのリクエスト
    token_url = "https://github.com/login/oauth/access_token"
    headers = {'Accept': 'application/json'}
    data = {
        'client_id': GITHUB_CLIENT_ID,
        'client_secret': GITHUB_CLIENT_SECRET,
        'code': code,
    }

    try:
        # アクセストークンの取得
        data_encoded = urllib.parse.urlencode(data).encode('utf-8')
        request = urllib.request.Request(token_url, data=data_encoded, headers=headers)

        with urllib.request.urlopen(request, timeout=10) as response:
            token_response = response.read().decode('utf-8')
            token_data = json.loads(token_response)

        if 'access_token' not in token_data:
            return {
                'statusCode': 400,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',  
                },
                'body': json.dumps({'error': 'Failed to retrieve access token.'})
            }

        access_token = token_data['access_token']

        # ユーザー情報の取得
        user_url = 'https://api.github.com/user'
        user_headers = {
            'Authorization': f'token {access_token}',
            'Accept': 'application/json'
        }

        user_request = urllib.request.Request(user_url, headers=user_headers)
        with urllib.request.urlopen(user_request) as user_response:
            user_info = json.loads(user_response.read().decode('utf-8'))

        # 日本時間の現在の日時を取得
        japan_time = datetime.datetime.now(ZoneInfo('Asia/Tokyo')) 
        last_feed_date = japan_time.strftime('%Y-%m-%d')

        # 必要なフィールドを抽出
        item = {
            'userId': str(user_info.get('id')),  
            'userName': user_info.get('login'),
            'avatarUrl': user_info.get('avatar_url'),
            'characterName': 'DASH',
            'characterLevel': int(1),
            'characterExperience': int(0),
            'characterClothes': 'default',
            'characterBackground': 'spring',
            'feedCount': int(0),
            'feededCount': int(0),
            'lastFeedDate': last_feed_date,
            'created_at': datetime.datetime.now(ZoneInfo("Asia/Tokyo")).isoformat(),
            'gsiPk': 'RANK',
        }

        table.put_item(Item=item)

        # GitHubのアクセストークンをレスポンスとして返す
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',  
            },
            'body': json.dumps({'access_token': access_token})
        }

    except urllib.error.URLError as e:
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',  
            },
            'body': json.dumps({'error': str(e)})
        }