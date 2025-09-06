import 'package:json_annotation/json_annotation.dart';

part 'auth_login.g.dart';

@JsonSerializable()
class AuthLogin {
  int statusCode;
  bool success;
  String message;

  Data? data;

  factory AuthLogin.fromJson(Map<String, dynamic> json) =>
      _$AuthLoginFromJson(json);

  Map<String, dynamic> toJson() => _$AuthLoginToJson(this);

  AuthLogin({
    required this.statusCode,
    required this.success,
    required this.message,
    this.data,
  });
}

@JsonSerializable()
class Data {
  String id;
  String email;
  String accessToken;
  String expiresIn;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  Data({
    required this.id,
    required this.email,
    required this.accessToken,
    required this.expiresIn,
  });
}
