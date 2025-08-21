class MyServicesModel {
  MyServicesModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final List<Datum> data;

  factory MyServicesModel.fromJson(Map<String, dynamic> json){
    return MyServicesModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.map((x) => x?.toJson()).toList(),
  };

}

class Datum {
  Datum({
    required this.id,
    required this.serviceProviderId,
    required this.serviceId,
    required this.availabilityStatusId,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
    required this.availabilityStatus,
  });

  final int id;
  final int serviceProviderId;
  final int serviceId;
  final int availabilityStatusId;
  final dynamic description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Service? service;
  final AvailabilityStatus? availabilityStatus;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"] ?? 0,
      serviceProviderId: json["service_provider_id"] ?? 0,
      serviceId: json["service_id"] ?? 0,
      availabilityStatusId: json["availability_status_id"] ?? 0,
      description: json["description"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      service: json["service"] == null ? null : Service.fromJson(json["service"]),
      availabilityStatus: json["availability_status"] == null ? null : AvailabilityStatus.fromJson(json["availability_status"]),
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
    "availability_status": availabilityStatus?.toJson(),
  };

}

class AvailabilityStatus {
  AvailabilityStatus({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AvailabilityStatus.fromJson(Map<String, dynamic> json){
    return AvailabilityStatus(
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
  final AvailabilityStatus? serviceCategory;

  factory Service.fromJson(Map<String, dynamic> json){
    return Service(
      id: json["id"] ?? 0,
      serviceCategoryId: json["service_category_id"] ?? 0,
      name: json["name"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      serviceCategory: json["service_category"] == null ? null : AvailabilityStatus.fromJson(json["service_category"]),
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
