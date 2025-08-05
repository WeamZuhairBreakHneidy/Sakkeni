
import '../../../data/models/properties-model.dart';

class PropertiesListModel {
  PropertiesListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final List<Datum>? data; // تم تغيير هذا الحقل ليكون قائمة من نوع Datum

  factory PropertiesListModel.fromJson(Map<String, dynamic> json) {
    return PropertiesListModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null
          ? null
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
