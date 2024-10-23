import 'package:json_annotation/json_annotation.dart';

part 'token_response.g.dart';

@JsonSerializable()
class TokenResponse {
  final String access_token;

  TokenResponse({required this.access_token});

  // fromJsonメソッド
  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);

  // toJsonメソッド
  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}
