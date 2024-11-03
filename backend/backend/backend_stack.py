import aws_cdk as cdk
from aws_cdk import (
    Duration,
    Stack,
    aws_lambda as _lambda,
    aws_ecr as ecr,
    aws_apigateway as apigateway,
    aws_iam as iam,
    aws_dynamodb as dynamodb,
    aws_s3 as s3,
    aws_s3_deployment as s3deploy,
    aws_cloudfront as cloudfront,
    aws_cloudfront_origins as origins,
    aws_iam,
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
            code=_lambda.Code.from_asset("lambda/auth"),
            timeout=Duration.seconds(10),
            memory_size=1024,
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
            code=_lambda.Code.from_asset("lambda/auth"),
            memory_size=1024,
            timeout=Duration.seconds(10),
        )

        # home画面遷移時に必要な情報を返すLambda関数
        home_lambda = _lambda.Function(
            self, "HomeLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="home.lambda_handler",
            code=_lambda.Code.from_asset("lambda/utils"),
            memory_size=1024,
            timeout=Duration.seconds(10),
        )
        # home_lambdaにDynamoDBテーブルへのアクセス権限を付与
        users_table.grant_read_write_data(home_lambda)
        
        # 餌を取得するLambda関数
        get_feed_lambda = _lambda.Function(
            self, "GetFeedLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="get_feed.lambda_handler",
            code=_lambda.Code.from_asset("lambda/utils"),
            memory_size=1024,
            timeout=Duration.seconds(10),
        )
        # get_feed_lambdaにDynamoDBテーブルへのアクセス権限を付与
        users_table.grant_read_write_data(get_feed_lambda)

        # 餌をあげて経験値を上昇させるLambda関数
        feed_lambda = _lambda.Function(
            self, "FeedLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="feed.lambda_handler",
            code=_lambda.Code.from_asset("lambda/utils"),
            memory_size=1024,
            timeout=Duration.seconds(10),
        )
        # feed_lambdaにDynamoDBテーブルへのアクセス権限を付与
        users_table.grant_read_write_data(feed_lambda)

        # ランキングを取得するLambda関数
        get_ranking_lambda = _lambda.Function(
            self, "GetRankingLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="ranking.lambda_handler",
            code=_lambda.Code.from_asset("lambda/utils"),
            memory_size=1024,
            timeout=Duration.seconds(10),
        )
        # get_ranking_lambdaにDynamoDBテーブルへのアクセス権限を付与
        users_table.grant_read_data(get_ranking_lambda)

        # Profileを変更するLambda関数
        update_profile_lambda = _lambda.Function(
            self, "UpdateProfileLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="update_profile.lambda_handler",
            code=_lambda.Code.from_asset("lambda/utils/bird_config"),
            memory_size=1024,
            timeout=Duration.seconds(10),
        )
        # change_profile_lambdaにDynamoDBテーブルへのアクセス権限を付与
        users_table.grant_read_write_data(update_profile_lambda)

        # 服装を変更するLambda関数
        change_clothes_lambda = _lambda.Function(
            self, "ChangeClothesLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="change_clothes.lambda_handler",
            code=_lambda.Code.from_asset("lambda/utils/bird_config"),
            memory_size=1024,
            timeout=Duration.seconds(10),
        )
        # change_clothes_lambdaにDynamoDBテーブルへのアクセス権限を付与
        users_table.grant_read_write_data(change_clothes_lambda)

        # 背景を変更するLambda関数
        change_background_lambda = _lambda.Function(
            self, "ChangeBackgroundLambda",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="change_background.lambda_handler",
            code=_lambda.Code.from_asset("lambda/utils/bird_config"),
            memory_size=1024,
            timeout=Duration.seconds(10),
        )
        # change_background_lambdaにDynamoDBテーブルへのアクセス権限を付与
        users_table.grant_read_write_data(change_background_lambda)

        # VoiceVoimeイメージ用のECRリポジトリを参照
        repository = ecr.Repository.from_repository_name(
            self, 'VoiceVoxRepository', repository_name='voicevox-lambda'
        )

        # VoiceVox用のLambda関数の定義
        voice_lambda = _lambda.DockerImageFunction(
            self, "VoiceLambda",
            code=_lambda.DockerImageCode.from_ecr(
                repository,
                tag="latest"
            ),
            memory_size=3008,
            timeout=Duration.seconds(30),
            architecture=_lambda.Architecture.X86_64
        )

        """
        alias = _lambda.Alias(
            self, "VoiceLambdaAlias",
            alias_name="prod",
            version=voice_lambda.current_version,
            provisioned_concurrent_executions=100  # プロビジョニング並行実行数
        )
        """

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
            "GET", 
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

        # /update_profileエンドポイント (Lambdaオーソライザを使用)
        profile_resource = api.root.add_resource("update_profile")
        profile_integration = apigateway.LambdaIntegration(update_profile_lambda)
        profile_resource.add_method(
            "PUT",
            profile_integration,
            authorization_type=apigateway.AuthorizationType.CUSTOM,
            authorizer=authorizer
        )

        # /change_clothesエンドポイント (Lambdaオーソライザを使用)
        change_clothes_resource = api.root.add_resource("change_clothes")
        change_clothes_integration = apigateway.LambdaIntegration(change_clothes_lambda)
        change_clothes_resource.add_method(
            "PUT",
            change_clothes_integration,
            authorization_type=apigateway.AuthorizationType.CUSTOM,
            authorizer=authorizer
        )

        # /change_backgroundエンドポイント (Lambdaオーソライザを使用)
        change_background_resource = api.root.add_resource("change_background")   
        change_background_integration = apigateway.LambdaIntegration(change_background_lambda)
        change_background_resource.add_method(
            "PUT",
            change_background_integration,
            authorization_type=apigateway.AuthorizationType.CUSTOM,
            authorizer=authorizer
        ) 

        # /voiceエンドポイント (Lambdaオーソライザを使用)
        voice_resource = api.root.add_resource("voice")
        voice_integration = apigateway.LambdaIntegration(voice_lambda)
        voice_resource.add_method(
            "POST",
            voice_integration,
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
            allow_methods=["GET", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )
        get_feed_resource.add_cors_preflight(
            allow_origins=["*"],  
            allow_methods=["POST", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )
        feed_resource.add_cors_preflight(
            allow_origins=["*"],  
            allow_methods=["POST", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )
        ranking_resource.add_cors_preflight(
            allow_origins=["*"],  
            allow_methods=["GET", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )
        profile_resource.add_cors_preflight(
            allow_origins=["*"],  
            allow_methods=["PUT", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )
        change_clothes_resource.add_cors_preflight(
            allow_origins=["*"],  
            allow_methods=["PUT", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )
        change_background_resource.add_cors_preflight(
            allow_origins=["*"],  
            allow_methods=["PUT", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )
        voice_resource.add_cors_preflight(
            allow_origins=["*"],  
            allow_methods=["POST", "OPTIONS"],  
            allow_headers=["Authorization", "Content-Type"], 
            allow_credentials=True 
        )
        
        # エンドポイントを出力
        cdk.CfnOutput(
            self, "ApiUrl",
            value=api.url
        )

        # Webプロジェクトデプロイ用のS3バケットの作成
        bucket = s3.Bucket(
            self,
            "FlutterWebBucket",
            public_read_access=False,
            block_public_access=s3.BlockPublicAccess.BLOCK_ALL,
            removal_policy=RemovalPolicy.DESTROY,
            auto_delete_objects=True,
            cors=[
                s3.CorsRule(
                    allowed_methods=[s3.HttpMethods.GET, s3.HttpMethods.HEAD],
                    allowed_origins=["*"],  
                    allowed_headers=["*"],  
                    exposed_headers=["ETag"],  
                )
            ]
        )

        # CloudFront用のオリジンアクセスアイデンティティの作成
        origin_access_identity = cloudfront.OriginAccessIdentity(self, "OAI")

        # バケットへの読み取り権限を付与（バケットポリシーを使用）
        bucket.add_to_resource_policy(
            iam.PolicyStatement(
                actions=["s3:GetObject"],
                resources=[bucket.arn_for_objects("*")],
                principals=[iam.CanonicalUserPrincipal(
                    origin_access_identity.cloud_front_origin_access_identity_s3_canonical_user_id)],
            )
)

        # CloudFrontディストリビューションの作成
        distribution = cloudfront.Distribution(
            self,
            "FlutterWebDistribution",
            default_root_object="index.html",
            default_behavior=cloudfront.BehaviorOptions(
                origin=origins.S3Origin(
                    bucket, origin_access_identity=origin_access_identity
                ),
                viewer_protocol_policy=cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
                response_headers_policy=cloudfront.ResponseHeadersPolicy.CORS_ALLOW_ALL_ORIGINS,  # CORSを許可
            ),
            error_responses=[
                cloudfront.ErrorResponse(
                    http_status=403,
                    response_http_status=200,
                    response_page_path="/index.html",
                    ttl=Duration.minutes(0),
                ),
                cloudfront.ErrorResponse(
                    http_status=404,
                    response_http_status=200,
                    response_page_path="/index.html",
                    ttl=Duration.minutes(0),
                ),
            ],
        )

        # Flutter WebビルドファイルをS3バケットにデプロイ
        s3deploy.BucketDeployment(
        self,
        "DeployFlutterWeb",
        sources=[s3deploy.Source.asset("../mobile/build/web")],
        destination_bucket=bucket,
        distribution=distribution,
        distribution_paths=["/*"],  # キャッシュを全て無効化
        )

        # CloudFrontディストリビューションのドメイン名を出力
        cdk.CfnOutput(
            self,
            "DistributionDomainName",
            value='https://' + distribution.distribution_domain_name,
        )
