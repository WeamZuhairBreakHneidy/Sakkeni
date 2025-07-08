class CountreiesModel {
  CountreiesModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final List<Datum> data;

  factory CountreiesModel.fromJson(Map<String, dynamic> json){
    return CountreiesModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };

}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.cities,
    required this.countryId,
  });

  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Datum> cities;
  final int countryId;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      cities: json["cities"] == null ? [] : List<Datum>.from(json["cities"]!.map((x) => Datum.fromJson(x))),
      countryId: json["country_id"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "cities": cities.map((x) => x.toJson()).toList(),
    "country_id": countryId,
  };

}
