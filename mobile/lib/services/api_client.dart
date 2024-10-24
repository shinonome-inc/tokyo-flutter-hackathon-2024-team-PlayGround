import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/models/token_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) {
    return _ApiClient(dio, baseUrl: dotenv.env['API_BASE_URL']);
  }

  @GET('/token')
  Future<HttpResponse<TokenResponse>> getAccessToken(
      @Query('code') String code);
}
