import 'package:json_annotation/json_annotation.dart';

part 'auth_request.g.dart';

@JsonSerializable()
class RegisterModel {
  int statusCode;
  bool success;
  String message;
  Data data;

  factory RegisterModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterModelToJson(this);

  RegisterModel({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.data,
  });
}

@JsonSerializable()
class Data {
  String id;
  String email;
  String userName;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  Data({required this.id, required this.email, required this.userName});
}
