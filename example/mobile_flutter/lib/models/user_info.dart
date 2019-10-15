
import 'package:json_annotation/json_annotation.dart';
part 'user_info.g.dart';

// flutter packages pub run build_runner build
@JsonSerializable(nullable: true)
class UserInfo{
  final String id;
  final String userName;
  final String email;
  final String avatar;
  final bool isAdmin;
  UserInfo({
    this.id,
    this.userName,
    this.avatar,
    this.email,
    this.isAdmin
    });

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
