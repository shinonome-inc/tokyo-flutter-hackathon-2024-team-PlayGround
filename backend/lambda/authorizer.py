import json
import requests
import urllib.request

def lambda_handler(event, context):
    # リクエストヘッダーからGitHubアクセストークンを取得
    token = event['authorizationToken']
    
    try:
        # GitHub APIでトークンを検証
        user_info_url = 'https://api.github.com/user'
        headers = {
                'Authorization': f'token {token}',
                'Accept': 'application/json'
            }
        user_request = urllib.request.Request(user_info_url, headers=headers)
        with urllib.request.urlopen(user_request) as user_response:
            user_info = json.loads(user_response.read().decode('utf-8'))

        # ユーザーIDを取得
        user_id = str(user_info.get('id'))
        return generate_policy('user', 'Deny', event['methodArn'], {'userId': user_id})
    
    except urllib.error.HTTPError as e:
        print(f"HTTPError: {e.code} - {e.reason}")
        return generate_policy('anonymous', 'Deny', event['methodArn'])
    except Exception as e:
        print(f"Error: {e}")
        return generate_policy('anonymous', 'Deny', event['methodArn'])

def generate_policy(principal_id, effect, resource, context=None):
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
    if context:
        auth_response['context'] = context # userIdをコンテキストに追加

    return auth_response
