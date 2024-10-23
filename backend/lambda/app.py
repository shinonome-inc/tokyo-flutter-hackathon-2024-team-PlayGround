import json
import os
import requests
from datetime import datetime, timedelta

def lambda_handler(event, context):
    # 環境変数からGitHubアクセストークンを取得
    github_token = event['headers'].get('Authorization')
    if not github_token:
        return {
            'statusCode': 401,
            'body': json.dumps({'error': 'Authorization token missing'})
        }
    
    # GitHub APIのURL (ユーザーのリポジトリ一覧)
    repos_url = 'https://api.github.com/user/repos'
    headers = {
        'Authorization': f'token {github_token}',
        'Accept': 'application/vnd.github.v3+json'
    }
    
    try:
        # 現在の時刻をUTCから日本時間（JST、UTC+9）に変換
        now_utc = datetime.utcnow()
        now_jst = now_utc + timedelta(hours=9)
        
        # 今日の開始時刻を日本時間の00:00:00に設定
        today_start_jst = datetime(now_jst.year, now_jst.month, now_jst.day, 0, 0, 0)
        
        # JSTの開始時刻をUTCに変換してGitHub APIのクエリに使う
        today_start_utc = today_start_jst - timedelta(hours=9)
        
        # 今日のコントリビュート数をカウントする
        total_contributions = 0

        # ユーザーのリポジトリを取得
        repos_response = requests.get(repos_url, headers=headers)
        repos = repos_response.json()

        if repos_response.status_code != 200:
            return {
                'statusCode': repos_response.status_code,
                'body': json.dumps({'error': 'Failed to fetch repositories'})
            }

        # 各リポジトリごとに、今日のコミットをカウント
        for repo in repos:
            owner = repo['owner']['login']
            repo_name = repo['name']
            commits_url = f'https://api.github.com/repos/{owner}/{repo_name}/commits'
            params = {
                'since': today_start_utc.isoformat() + 'Z'  # 日本時間の00:00:00をUTCに変換した時間を使用
            }
            commits_response = requests.get(commits_url, headers=headers, params=params)
            commits = commits_response.json()

            if commits_response.status_code == 200:
                # 今日のコミット数をカウント
                total_contributions += len(commits)

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Successfully fetched contributions for today (JST)',
                'total_contributions_today': total_contributions
            })
        }
    
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
