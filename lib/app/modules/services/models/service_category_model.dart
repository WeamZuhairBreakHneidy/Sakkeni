import 'service_item_model.dart';

class ServiceCategory {
  final int id;
  final String name;
  final List<ServiceItem> services;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.services,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    List<ServiceItem> serviceList = [];

    if (json['services'] != null) {
      if (json['services'] is List) {
        serviceList = (json['services'] as List)
            .map((e) => ServiceItem.fromJson(e))
            .toList();
      } else {
        serviceList = [ServiceItem.fromJson(json['services'])];
      }
    }

    return ServiceCategory(
      id: json['id'],
      name: json['name'],
      services: serviceList,
    );
  }
}
