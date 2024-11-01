import json
import datetime
import urllib.request
import boto3
import decimal

# DynamoDBからユーザー情報を取得
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users')

def lambda_handler(event, context):    
    # LambdaAuthorizerから渡されたユーザーID
    user_id = event['requestContext']['authorizer']['userId']

    # Authorizationトークンを取得
    authorization_token = event['headers'].get('Authorization')
    if not authorization_token:
        return {
            'statusCode': 401,
            'body': json.dumps({'error': 'Authorization header missing'})
        }
    
    # GitHubのusernameを取得
    github_username = get_github_username(authorization_token)
    if not github_username:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Failed to retrieve GitHub username'})
        }
    
    # 現在のUTC時刻を取得し、日本時間に変換
    utc_now = datetime.datetime.now(datetime.timezone.utc)
    jst_timezone = datetime.timezone(datetime.timedelta(hours=9))
    jst_now = utc_now.astimezone(jst_timezone)

    # 今日の0時0分0秒に設定
    start_of_day = jst_now.replace(hour=0, minute=0, second=0, microsecond=0).isoformat()
    # 今日の23時59分59秒に設定
    end_of_day = jst_now.replace(hour=23, minute=59, second=59, microsecond=999999).isoformat()

    # GraphQLクエリ
    query = """
    query($login: String!, $from: DateTime!, $to: DateTime!) {
      user(login: $login) {
        contributionsCollection(from: $from, to: $to) {
          commitContributionsByRepository(maxRepositories: 100) {
            repository {
              name
              languages(first: 10) {
                nodes {
                  name
                }
              }
            }
            contributions {
              totalCount
            }
          }
          issueContributionsByRepository(maxRepositories: 100) {
            repository {
              name
              languages(first: 10) {
                nodes {
                  name
                }
              }
            }
            contributions {
              totalCount
            }
          }
          pullRequestContributionsByRepository(maxRepositories: 100) {
            repository {
              name
              languages(first: 10) {
                nodes {
                  name
                }
              }
            }
            contributions {
              totalCount
            }
          }
        }
      }
    }
    """
    
    # GraphQLの変数
    variables = {
        'login': github_username,
        'from': start_of_day,
        'to': end_of_day
    }
    
    # リクエストデータの設定
    data = json.dumps({'query': query, 'variables': variables}).encode('utf-8')
    headers = {
        'Authorization': f'token {authorization_token}',
        'Content-Type': 'application/json'
    }
    request = urllib.request.Request(
        'https://api.github.com/graphql', 
        data=data, 
        headers=headers, 
        method='POST'
    )
    
    try:
        with urllib.request.urlopen(request) as response:
            response_data = json.loads(response.read().decode('utf-8'))
        print(response_data)

        # Dartを含むリポジトリでのコントリビューション数を集計
        dart_contributions = 0
        for contribution_type in ['commitContributionsByRepository', 'issueContributionsByRepository', 'pullRequestContributionsByRepository']:
            dart_contributions += sum(
                repo['contributions']['totalCount']
                for repo in response_data['data']['user']['contributionsCollection'][contribution_type]
                if any(lang['name'] == 'Dart' for lang in repo['repository']['languages']['nodes'])
            )
        try:
            item = table.get_item(Key={'userId': user_id})
            feeded_count = int(item['Item'].get('feededCount', decimal.Decimal(0)))

            # 残りの給餌可能回数を計算
            feed_count = max(dart_contributions - feeded_count, 0)

            table.update_item(
                Key={'userId': user_id},
                UpdateExpression="SET feedCount = :feed_count",
                ExpressionAttributeValues={
                    ':feed_count': feed_count
                }
            )
        except Exception as e:
            return {
                'statusCode': 500,
                'body': f"Error updating DynamoDB: {str(e)}"
            }
        return {
            'statusCode': 200,
            'body': json.dumps({'feedCount': feed_count})
        }
    
    except Exception as e:
        print(f"Error fetching contributions: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Failed to fetch contributions'})
        }

def get_github_username(access_token):
    # GitHubのユーザー名を取得する関数
    url = 'https://api.github.com/user'
    headers = {
        'Authorization': f'token {access_token}',
        'Content-Type': 'application/json'
    }
    request = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(request) as response:
            user_data = json.loads(response.read().decode('utf-8'))
        return user_data.get('login')
    except Exception as e:
        print(f"Error fetching GitHub username: {e}")
        return None