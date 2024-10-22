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
        token_response = requests.post(token_url, headers=headers, data=data).json()

        if 'access_token' not in token_response:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Failed to retrieve access token.'})
            }

        access_token = token_response['access_token']

        # GitHubのユーザー情報を取得するリクエスト
        user_info_url = 'https://api.github.com/user'
        user_info_response = requests.get(
            user_info_url,
            headers={'Authorization': f'token {access_token}'}
        ).json()

        if 'id' not in user_info_response:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Failed to retrieve user information.'})
            }

        # GitHubのユーザー情報をレスポンスとして返す
        return {
            'statusCode': 200,
            'body': json.dumps({
                'id': user_info_response['id'],
                'login': user_info_response['login'],
                'email': user_info_response.get('email', 'No public email'),
                'avatar_url': user_info_response['avatar_url'],
                'html_url': user_info_response['html_url']
            })
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
