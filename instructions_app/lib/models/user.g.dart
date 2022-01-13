// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserIdentity _$UserFromJson(Map<String, dynamic> json) {
  return UserIdentity(
      id: json['id'] as String,
      email: json['email'] as String,
      password: json['password'] as String);
}

Map<String, dynamic> _$UserToJson(UserIdentity instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password
    };