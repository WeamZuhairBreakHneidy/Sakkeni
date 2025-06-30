// user_model.dart
class UserModel {
  final int id;
  final String firstName;
  final String lastName;
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
    required this.firstName,
    required this.lastName,
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
      firstName: json['first_name'],
      lastName: json['last_name'],
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
      'first_name': firstName,
      'last_name': lastName,
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
  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? address,
    String? token,
    String? profilePicturePath,
  }) {
    return UserModel(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      token: token ?? this.token,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      isAdmin: isAdmin,
      isSuperAdmin: isSuperAdmin,
      emailVerifiedAt: emailVerifiedAt,
    );
  }


}
