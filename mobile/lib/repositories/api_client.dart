import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'token_response.dart';

part 'api_client.g.dart';

@RestApi(
    baseUrl:
        "https://fyc67kc5i3.execute-api.ap-northeast-1.amazonaws.com/prod/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/token")
  Future<HttpResponse<TokenResponse>> getAccessToken(
      @Query("code") String code);
}
