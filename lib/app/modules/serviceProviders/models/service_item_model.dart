
class ServiceItem {
  final int id;
  final String name;

  ServiceItem({
    required this.id,
    required this.name,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'],
      name: json['name'],
    );
  }
}