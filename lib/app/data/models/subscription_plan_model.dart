class SubscriptionPlanModel {
  SubscriptionPlanModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final List<Datum> data;

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json){
    return SubscriptionPlanModel(
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
    required this.name,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final num price;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      price: json["price"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}
