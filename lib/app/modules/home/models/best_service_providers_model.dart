class BestServiceProvidersModel {
  BestServiceProvidersModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final Data? data;

  factory BestServiceProvidersModel.fromJson(Map<String, dynamic> json){
    return BestServiceProvidersModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
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
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  final num currentPage;
  final List<Datum> data;
  final String firstPageUrl;
  final num from;
  final num lastPage;
  final String lastPageUrl;
  final List<Link> links;
  final dynamic nextPageUrl;
  final String path;
  final num perPage;
  final dynamic prevPageUrl;
  final num to;
  final num total;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      currentPage: json["current_page"] ?? 0,
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      firstPageUrl: json["first_page_url"] ?? "",
      from: json["from"] ?? 0,
      lastPage: json["last_page"] ?? 0,
      lastPageUrl: json["last_page_url"] ?? "",
      links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
      nextPageUrl: json["next_page_url"],
      path: json["path"] ?? "",
      perPage: json["per_page"] ?? 0,
      prevPageUrl: json["prev_page_url"],
      to: json["to"] ?? 0,
      total: json["total"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data.map((x) => x?.toJson()).toList(),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links.map((x) => x?.toJson()).toList(),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };

}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.rate,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.serviceProviderServices,
  });

  final int id;
  final int userId;
  final dynamic rate;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;
  final List<ServiceProviderService> serviceProviderServices;

  // Getter للحصول على اسم الخدمة الأولى (إن وجدت)
  String get firstServiceName =>
      serviceProviderServices.isNotEmpty
          ? serviceProviderServices.first.service?.name ?? ""
          : "";

  // Getter للحصول على اسم الفئة الأولى (إن وجدت)
  String get firstServiceCategoryName =>
      serviceProviderServices.isNotEmpty
          ? serviceProviderServices.first.service?.serviceCategory?.name ?? ""
          : "";

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      rate: json["rate"],
      description: json["description"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      serviceProviderServices: json["service_provider_services"] == null ? [] : List<ServiceProviderService>.from(json["service_provider_services"]!.map((x) => ServiceProviderService.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "rate": rate,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
    "service_provider_services": serviceProviderServices.map((x) => x.toJson()).toList(),
  };
}

class ServiceProviderService {
  ServiceProviderService({
    required this.id,
    required this.serviceProviderId,
    required this.serviceId,
    required this.availabilityStatusId,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
  });

  final int id;
  final int serviceProviderId;
  final int serviceId;
  final int availabilityStatusId;
  final dynamic description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Service? service;

  factory ServiceProviderService.fromJson(Map<String, dynamic> json){
    return ServiceProviderService(
      id: json["id"] ?? 0,
      serviceProviderId: json["service_provider_id"] ?? 0,
      serviceId: json["service_id"] ?? 0,
      availabilityStatusId: json["availability_status_id"] ?? 0,
      description: json["description"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      service: json["service"] == null ? null : Service.fromJson(json["service"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_provider_id": serviceProviderId,
    "service_id": serviceId,
    "availability_status_id": availabilityStatusId,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "service": service?.toJson(),
  };

}

class Service {
  Service({
    required this.id,
    required this.serviceCategoryId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceCategory,
  });

  final int id;
  final int serviceCategoryId;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ServiceCategory? serviceCategory;

  factory Service.fromJson(Map<String, dynamic> json){
    return Service(
      id: json["id"] ?? 0,
      serviceCategoryId: json["service_category_id"] ?? 0,
      name: json["name"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      serviceCategory: json["service_category"] == null ? null : ServiceCategory.fromJson(json["service_category"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_category_id": serviceCategoryId,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "service_category": serviceCategory?.toJson(),
  };

}

class ServiceCategory {
  ServiceCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ServiceCategory.fromJson(Map<String, dynamic> json){
    return ServiceCategory(
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

class User {
  User({
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
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final dynamic emailVerifiedAt;
  final dynamic profilePicturePath;
  final String address;
  final String phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"] ?? 0,
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      email: json["email"] ?? "",
      emailVerifiedAt: json["email_verified_at"],
      profilePicturePath: json["profile_picture_path"],
      address: json["address"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "profile_picture_path": profilePicturePath,
    "address": address,
    "phone_number": phoneNumber,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  final String url;
  final String label;
  final bool active;

  factory Link.fromJson(Map<String, dynamic> json){
    return Link(
      url: json["url"] ?? "",
      label: json["label"] ?? "",
      active: json["active"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };

}
