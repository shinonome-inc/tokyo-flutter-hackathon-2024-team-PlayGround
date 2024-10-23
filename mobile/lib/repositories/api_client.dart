import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'token_response.dart'; // モデルクラスをインポート

part 'api_client.g.dart';

@RestApi(baseUrl: "https://your-api-gateway-url")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/token")
  Future<HttpResponse<TokenResponse>> getAccessToken(
      @Query("code") String code);
}
