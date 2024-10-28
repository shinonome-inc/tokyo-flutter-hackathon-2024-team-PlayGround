import json
import os
import requests
from datetime import datetime, timedelta

def lambda_handler(event, context):
    # LambdaAuthorizerから渡されたユーザーID
    user_id = event['requestContext']['authorizer']['userId']