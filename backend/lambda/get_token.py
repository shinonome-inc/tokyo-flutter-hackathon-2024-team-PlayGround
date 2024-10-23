import json
import requests
import os

# Lambdaの環境変数からGitHub OAuthのクライアントIDとクライアントシークレットを取得
GITHUB_CLIENT_ID = os.environ['GITHUB_CLIENT_ID']
GITHUB_CLIENT_SECRET = os.environ['GITHUB_CLIENT_SECRET']

def lambda_handler(event, context):
    # API Gateway経由で受け取るGitHub認証コード
    body = json.loads(event['body'])
    code = body.get('code')

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
        'code': code
    }

    try:
        # アクセストークンの取得
        token_response = requests.post(token_url, headers=headers, data=data, timeout=10)
        token_data = token_response.json()

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

        # GitHubのアクセストークンをレスポンスとして返す
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',  
            },
            'body': json.dumps({'access_token': access_token})
        }

    except requests.exceptions.RequestException as e:
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',  
            },
            'body': json.dumps({'error': str(e)})
        }
