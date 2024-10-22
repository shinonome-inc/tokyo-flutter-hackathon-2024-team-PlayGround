import json
import requests

def lambda_handler(event, context):
    # リクエストヘッダーからGitHubアクセストークンを取得
    token = event['authorizationToken']
    
    # GitHub APIでトークンを検証
    user_info_url = 'https://api.github.com/user'
    headers = {'Authorization': f'token {token}'}
    response = requests.get(user_info_url, headers=headers)
    
    if response.status_code == 200:
        # トークンが有効なら、ユーザー情報を元にポリシーを生成
        user_info = response.json()
        return generate_policy(user_info['id'], 'Allow', event['methodArn'])
    
    # トークンが無効なら、拒否ポリシーを返す
    return generate_policy('user', 'Deny', event['methodArn'])

def generate_policy(principal_id, effect, resource):
    """IAMポリシーを生成"""
    auth_response = {
        'principalId': principal_id
    }
    if effect and resource:
        auth_response['policyDocument'] = {
            'Version': '2012-10-17',
            'Statement': [
                {
                    'Action': 'execute-api:Invoke',
                    'Effect': effect,
                    'Resource': resource
                }
            ]
        }
    return auth_response
