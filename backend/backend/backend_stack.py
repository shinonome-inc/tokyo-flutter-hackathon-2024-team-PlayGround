import aws_cdk as cdk
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

load_dotenv()

class BackendStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        github_client_id = os.getenv('GITHUB_CLIENT_ID')
        github_client_secret = os.getenv('GITHUB_CLIENT_SECRET')

        # DynamoDBテーブル作成
        users_table = dynamodb.Table(
            self, "UsersTable",
            table_name="Users",
            partition_key=dynamodb.Attribute(
                name="userID",
                type=dynamodb.AttributeType.STRING
            ),
            billing_mode=dynamodb.BillingMode.PAY_PER_REQUEST,  # オンデマンド課金（書き込み1.25$/1M, 読み出し0.25$/1M）
            removal_policy=cdk.RemovalPolicy.DESTROY  # スタック削除時にテーブルを削除
        )
        users_table.add_global_secondary_index(
            index_name="RankIndex",
            partition_key=dynamodb.Attribute(
                name="gsiPk",
                type=dynamodb.AttributeType.STRING
            ),
            sort_key=dynamodb.Attribute(
                name="characterLevel",
                type=dynamodb.AttributeType.NUMBER
            ),
            projection_type=dynamodb.ProjectionType.ALL
        )

        # GitHub認証コードを使ってアクセストークンを取得するLambda関数
        get_token_lambda = _lambda.Function(
            self, "GetTokenLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="get_token.lambda_handler",
            code=_lambda.Code.from_asset("lambda"),
            timeout=Duration.seconds(10),
            environment={
                'GITHUB_CLIENT_ID': github_client_id,
                'GITHUB_CLIENT_SECRET': github_client_secret
            }
        )

        # Lambdaオーソライザ (GitHubアクセストークンを検証)
        auth_lambda = _lambda.Function(
            self, "AuthLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="auth.lambda_handler",
            code=_lambda.Code.from_asset("lambda"),
            timeout=Duration.seconds(10),
        )

        # アプリロジック用のLambda関数
        app_lambda = _lambda.Function(
            self, "AppLogicLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="app.lambda_handler",
            code=_lambda.Code.from_asset("lambda"),
            timeout=Duration.seconds(10),
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
        user_resource = api.root.add_resource("contributes")
        user_integration = apigateway.LambdaIntegration(app_lambda)
        user_resource.add_method(
            "GET", 
            user_integration,
            authorization_type=apigateway.AuthorizationType.CUSTOM,
            authorizer=authorizer
        )

        # CORSを有効にする
        token_resource.add_cors_preflight(
            allow_origins=["*"],  
            allow_methods=["GET", "POST", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )
        user_resource.add_cors_preflight(
            allow_origins=["*"],  
            allow_methods=["GET", "POST", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )

        cdk.CfnOutput(
            self, "ApiUrl",
            value=api.url
        )