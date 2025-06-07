// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      phone: json['phone'] as String,
      fullname: json['fullname'] as String,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      is2FAEnabled: json['is2FAEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'fullname': instance.fullname,
      'email': instance.email,
      'avatar': instance.avatar,
      'is2FAEnabled': instance.is2FAEnabled,
    };
