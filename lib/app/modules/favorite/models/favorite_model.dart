import '../../../data/models/properties-model.dart';

class FavoriteModel {
  final bool status;
  final String message;
  final FavoriteData? data;

  FavoriteModel({required this.status, required this.message, this.data});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : FavoriteData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class FavoriteData {
  final int currentPage;
  final List<FavoriteDatum> data;

  FavoriteData({required this.currentPage, required this.data});

  factory FavoriteData.fromJson(Map<String, dynamic> json) {
    return FavoriteData(
      currentPage: json["current_page"] ?? 0,
      data:
          json["data"] == null
              ? []
              : List<FavoriteDatum>.from(
                json["data"].map((x) => FavoriteDatum.fromJson(x)),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class FavoriteDatum {
  final int id;
  final int propertyId;
  final Datum? property;

  FavoriteDatum({required this.id, required this.propertyId, this.property});

  factory FavoriteDatum.fromJson(Map<String, dynamic> json) {
    return FavoriteDatum(
      id: json["id"] ?? 0,
      propertyId: json["property_id"] ?? 0,
      property:
          json["property"] == null ? null : Datum.fromJson(json["property"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_id": propertyId,
    "property": property?.toJson(),
  };
}
