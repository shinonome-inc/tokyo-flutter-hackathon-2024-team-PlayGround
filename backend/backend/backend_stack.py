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
                name="userId",
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
        # get_token_lambdaにDynamoDBテーブルへのアクセス権限を付与
        users_table.grant_read_write_data(get_token_lambda)

        # Lambdaオーソライザ (GitHubアクセストークンを検証)
        auth_lambda = _lambda.Function(
            self, "AuthLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="authorizer.lambda_handler",
            code=_lambda.Code.from_asset("lambda"),
            timeout=Duration.seconds(10),
        )

        # home画面遷移時に必要な情報を返すLambda関数
        home_lambda = _lambda.Function(
            self, "HomeLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="home.lambda_handler",
            code=_lambda.Code.from_asset("lambda"),
            timeout=Duration.seconds(10),
        )
        # home_lambdaにDynamoDBテーブルへのアクセス権限を付与
        users_table.grant_read_write_data(home_lambda)
        
        # 餌を取得するLambda関数
        get_feed_lambda = _lambda.Function(
            self, "GetFeedLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="get_feed.lambda_handler",
            code=_lambda.Code.from_asset("lambda"),
            timeout=Duration.seconds(10),
        )
        # get_feed_lambdaにDynamoDBテーブルへのアクセス権限を付与
        users_table.grant_read_write_data(get_feed_lambda)

        # 餌をあげて経験値を上昇させるLambda関数
        feed_lambda = _lambda.Function(
            self, "FeedLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="feed.lambda_handler",
            code=_lambda.Code.from_asset("lambda"),
            timeout=Duration.seconds(10),
        )
        # feed_lambdaにDynamoDBテーブルへのアクセス権限を付与
        users_table.grant_read_write_data(feed_lambda)

        # ランキングを取得するLambda関数
        get_ranking_lambda = _lambda.Function(
            self, "GetRankingLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="ranking.lambda_handler",
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
            identity_source="method.request.header.Authorization",  # ヘッダーからトークンを取得
            results_cache_ttl=Duration.seconds(0),  # キャッシュを無効化
        )

        # /tokenエンドポイント (アクセストークン取得用)
        token_resource = api.root.add_resource("token")
        token_integration = apigateway.LambdaIntegration(get_token_lambda)
        token_resource.add_method("GET", token_integration)

        # /homeエンドポイント (Lambdaオーソライザを使用)
        home_resource = api.root.add_resource("home")
        home_integration = apigateway.LambdaIntegration(home_lambda)
        home_resource.add_method(
            "POST", 
            home_integration,
            authorization_type=apigateway.AuthorizationType.CUSTOM,
            authorizer=authorizer,
        )

        # /get_feedエンドポイント (Lambdaオーソライザを使用)
        get_feed_resource = api.root.add_resource("get_feed")
        get_feed_integration = apigateway.LambdaIntegration(get_feed_lambda)
        get_feed_resource.add_method(
            "POST", 
            get_feed_integration,
            authorization_type=apigateway.AuthorizationType.CUSTOM,
            authorizer=authorizer
        )

        # /feedエンドポイント (Lambdaオーソライザを使用)
        feed_resource = api.root.add_resource("feed")
        feed_integration = apigateway.LambdaIntegration(feed_lambda)
        feed_resource.add_method(
            "POST", 
            feed_integration,
            authorization_type=apigateway.AuthorizationType.CUSTOM,
            authorizer=authorizer
        )

        # /rankingエンドポイント (Lambdaオーソライザを使用)
        ranking_resource = api.root.add_resource("ranking")
        ranking_integration = apigateway.LambdaIntegration(get_ranking_lambda)
        ranking_resource.add_method(
            "GET",
            ranking_integration,
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
        home_resource.add_cors_preflight(
            allow_origins=["*"],  
            allow_methods=["GET", "POST", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )
        get_feed_resource.add_cors_preflight(
            allow_origins=["*"],  
            allow_methods=["GET", "POST", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )
        feed_resource.add_cors_preflight(
            allow_origins=["*"],  
            allow_methods=["GET", "POST", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )
        ranking_resource.add_cors_preflight(
            allow_origins=["*"],  
            allow_methods=["GET", "POST", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )
        
        # エンドポイントを出力
        cdk.CfnOutput(
            self, "ApiUrl",
            value=api.url
        )