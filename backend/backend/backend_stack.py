from aws_cdk import (
    Duration,
    Stack,
    aws_lambda as _lambda,
    aws_apigateway as apigateway,
    aws_iam as iam,
    aws_dynamodb as dynamodb,
    RemovalPolicy
)
from constructs import Construct
import os
from dotenv import load_dotenv
from constructs import Construct

class BackendStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # DynamoDBテーブルの作成
        

        # GitHub認証コードを使ってアクセストークンを取得するLambda関数
        get_token_lambda = _lambda.Function(
            self, "GetTokenLambda",
            runtime=_lambda.Runtime.PYTHON_3_8,
            handler="get_token.lambda_handler",
            code=_lambda.Code.from_asset("lambda"),
            environment={
                'GITHUB_CLIENT_ID': '',
                'GITHUB_CLIENT_SECRET': ''
            }
        )

        # Lambdaオーソライザ (GitHubアクセストークンを検証)
        auth_lambda = _lambda.Function(
            self, "AuthLambda",
            runtime=_lambda.Runtime.PYTHON_3_8,
            handler="auth.lambda_handler",
            code=_lambda.Code.from_asset("lambda")
        )

        # アプリロジック用のLambda関数
        app_logic_lambda = _lambda.Function(
            self, "AppLogicLambda",
            runtime=_lambda.Runtime.PYTHON_3_8,
            handler="app_logic.lambda_handler",
            code=_lambda.Code.from_asset("lambda")
        )

        # API Gatewayの定義
        api = apigateway.RestApi(
            self, "ReposiToriApi",
            rest_api_name="ReposiToriApi",
        )

        # Lambdaオーソライザの定義
        authorizer = apigateway.TokenAuthorizer(
            self, "GitHubAuthorizer",
            handler=auth_lambda,
            identity_source="method.request.header.Authorization"  # ヘッダーからトークンを取得
        )

        # /tokenエンドポイント (アクセストークン取得用)
        token_resource = api.root.add_resource("token")
        token_integration = apigateway.LambdaIntegration(get_token_lambda)
        token_resource.add_method("GET", token_integration)

        # /userエンドポイント (アプリロジック用、Lambdaオーソライザを使用)
        user_resource = api.root.add_resource("user")
        user_integration = apigateway.LambdaIntegration(app_logic_lambda)
        user_resource.add_method(
            "GET", 
            user_integration,
            authorization_type=apigateway.AuthorizationType.CUSTOM,
            authorizer=authorizer
        )