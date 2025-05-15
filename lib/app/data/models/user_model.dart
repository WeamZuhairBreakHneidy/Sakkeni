// user_model.dart
class UserModel {
  final int id;
  final String username;
  final String email;
  final String? emailVerifiedAt;
  final String? profilePicturePath;
  final String? address;
  final String? phoneNumber;
  final bool isAdmin;
  final bool isSuperAdmin;

  final String token;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.emailVerifiedAt,
    this.profilePicturePath,
    this.address,
    this.phoneNumber,
    required this.isAdmin,
    required this.isSuperAdmin,

    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      profilePicturePath: json['profile_picture_path'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      isAdmin: json['is_admin'] == 1,
      isSuperAdmin: json['is_super_admin'] == 1,

      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'profile_picture_path': profilePicturePath,
      'address': address,
      'phone_number': phoneNumber,
      'is_admin': isAdmin ? 1 : 0,
      'is_super_admin': isSuperAdmin ? 1 : 0,

      'token': token,
    };
  }
}
