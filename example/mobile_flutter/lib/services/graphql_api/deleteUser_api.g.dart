// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleteUser_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteUser _$DeleteUserFromJson(Map<String, dynamic> json) {
  return DeleteUser()
    ..deleteUser = json['deleteUser'] == null
        ? null
        : User.fromJson(json['deleteUser'] as Map<String, dynamic>);
}

Map<String, dynamic> _$DeleteUserToJson(DeleteUser instance) =>
    <String, dynamic>{
      'deleteUser': instance.deleteUser?.toJson(),
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User()..Username = json['Username'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'Username': instance.Username,
    };

DeleteUserArguments _$DeleteUserArgumentsFromJson(Map<String, dynamic> json) {
  return DeleteUserArguments(
    userName: json['userName'] as String,
  );
}

Map<String, dynamic> _$DeleteUserArgumentsToJson(
        DeleteUserArguments instance) =>
    <String, dynamic>{
      'userName': instance.userName,
    };
