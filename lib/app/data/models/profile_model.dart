class ProfileModel {
  ProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final Data? data;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null ? Data.fromJson(json["data"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.emailVerifiedAt,
    required this.profilePicturePath,
    required this.address,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.seller,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final Seller? seller;  // هنا تغيرنا من String لـ Seller?
  final dynamic emailVerifiedAt;
  final dynamic profilePicturePath;
  final dynamic address;
  final dynamic phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"] ?? 0,
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      seller: json["seller"] != null ? Seller.fromJson(json["seller"]) : null,
      email: json["email"] ?? "",
      emailVerifiedAt: json["email_verified_at"],
      profilePicturePath: json["profile_picture_path"],
      address: json["address"],
      phoneNumber: json["phone_number"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "seller": seller?.toJson(),
    "email_verified_at": emailVerifiedAt,
    "profile_picture_path": profilePicturePath,
    "address": address,
    "phone_number": phoneNumber,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Seller {
  Seller({
    required this.id,
    required this.userId,
    required this.accountTypeId,
    required this.freeAdsLeft,
    required this.createdAt,
    required this.updatedAt,
    required this.accountType,
  });

  final int id;
  final int userId;
  final int accountTypeId;
  final int freeAdsLeft;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final AccountType? accountType;

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      accountTypeId: json["account_type_id"] ?? 0,
      freeAdsLeft: json["free_ads_left"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      accountType: json["account_type"] != null
          ? AccountType.fromJson(json["account_type"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "account_type_id": accountTypeId,
    "free_ads_left": freeAdsLeft,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "account_type": accountType?.toJson(),
  };
}

class AccountType {
  AccountType({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AccountType.fromJson(Map<String, dynamic> json) {
    return AccountType(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
