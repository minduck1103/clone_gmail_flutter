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
    String? avatarUrl =
        json['profileImage']?.toString() ?? json['avatar']?.toString();

    // If avatar is not null and not a full URL, prepend base URL
    if (avatarUrl != null &&
        avatarUrl.isNotEmpty &&
        !avatarUrl.startsWith('http')) {
      // This will be used if backend doesn't provide full URL
      avatarUrl = 'http://10.0.2.2:5000$avatarUrl';
    }

    return User(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      fullname: json['fullname']?.toString() ?? '',
      email: json['email']?.toString(),
      avatar: avatarUrl,
      is2FAEnabled:
          json['is2FAEnabled'] == true || json['twoFactorEnabled'] == true,
    );
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
