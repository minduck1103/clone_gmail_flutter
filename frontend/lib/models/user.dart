import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String phone;
  final String fullname;
  final String? email;
  final String? avatar;
  final bool is2FAEnabled;

  User({
    required this.id,
    required this.phone,
    required this.fullname,
    this.email,
    this.avatar,
    this.is2FAEnabled = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      fullname: json['fullname']?.toString() ?? '',
      email: json['email']?.toString(),
      avatar: json['avatar']?.toString(),
      is2FAEnabled:
          json['is2FAEnabled'] == true || json['twoFactorEnabled'] == true,
    );
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
