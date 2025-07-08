class ProfileModel {
  ProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final Data? data;

  // factory ProfileModel.fromJson(Map<String, dynamic> json) {
  //   final dataList = json["data"];
  //   return ProfileModel(
  //     status: json["status"] ?? false,
  //     message: json["message"] ?? "",
  //     data: (dataList != null && dataList is List && dataList.isNotEmpty)
  //         ? Data.fromJson(dataList[0])
  //         : null,
  //   );
  // }
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
  final String seller;
  final dynamic emailVerifiedAt;
  final dynamic profilePicturePath;
  final dynamic address;
  final dynamic phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"] ?? 0,
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      seller: json["seller"] ?? "",
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
    "seller": seller,
    "email_verified_at": emailVerifiedAt,
    "profile_picture_path": profilePicturePath,
    "address": address,
    "phone_number": phoneNumber,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}
