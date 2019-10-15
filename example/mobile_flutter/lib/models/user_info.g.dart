// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
    id: json['id'] as String,
    userName: json['userName'] as String,
    avatar: json['avatar'] as String,
    email: json['email'] as String,
    isAdmin: json['isAdmin'] as bool,
  );
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'email': instance.email,
      'avatar': instance.avatar,
      'isAdmin': instance.isAdmin,
    };
