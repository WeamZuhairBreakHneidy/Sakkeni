class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? emailVerifiedAt;
  final String? profilePicturePath;
  final String? address;
  final String? phoneNumber;
  final String token;

  // Flags
  final bool isSeller;
  final bool isServiceProvider;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.emailVerifiedAt,
    this.profilePicturePath,
    this.address,
    this.phoneNumber,
    required this.token,
    required this.isSeller,
    required this.isServiceProvider,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List accountTypes = json['account_type'] ?? [];

    return UserModel(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      profilePicturePath: json['profile_picture_path'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      token: json['token'] ?? '',
      isSeller: accountTypes.contains("Seller"),
      isServiceProvider: accountTypes.contains("Service Provider"),
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
      'token': token,
      'is_seller': isSeller,
      'is_service_provider': isServiceProvider,
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
    bool? isSeller,
    bool? isServiceProvider,
    String? emailVerifiedAt,
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
      isSeller: isSeller ?? this.isSeller,
      isServiceProvider: isServiceProvider ?? this.isServiceProvider,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
    );
  }
}
