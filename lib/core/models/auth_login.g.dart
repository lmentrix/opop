// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthLogin _$AuthLoginFromJson(Map<String, dynamic> json) => AuthLogin(
  statusCode: (json['statusCode'] as num).toInt(),
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : Data.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthLoginToJson(AuthLogin instance) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  id: json['id'] as String,
  email: json['email'] as String,
  accessToken: json['accessToken'] as String,
  expiresIn: json['expiresIn'] as String,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'accessToken': instance.accessToken,
  'expiresIn': instance.expiresIn,
};
