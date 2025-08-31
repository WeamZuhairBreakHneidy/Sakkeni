import 'package:flutter/material.dart';

class ServiceItem {
  final int id;
  final String name;
  final IconData icon;
  final String image;

  ServiceItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.image,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final iconImage = _getIconAndImage(name);

    return ServiceItem(
      id: json['id'],
      name: name,
      icon: iconImage['icon'],
      image: iconImage['image'],
    );
  }

  static Map<String, dynamic> _getIconAndImage(String serviceName) {
    // normalize filename: lowercase + replace spaces with "_"
    final normalized = serviceName.toLowerCase().replaceAll(" ", "_");

    String imagePath = "assets/services/${serviceName}.jpg";

    switch (normalized) {
      case "carpenter":
        return {"icon": Icons.construction, "image": "assets/services/Carpenter.jpg"};
      case "metalwork":
        return {"icon": Icons.handyman, "image": "assets/services/Metal_work.jpg"};
      case "deep_cleaning":
        return {"icon": Icons.cleaning_services, "image": "assets/services/Deep cleaning.jpg"};
      case "regular_cleaning":
        return {"icon": Icons.clean_hands, "image":"assets/services/Regular_cleaning.jpg"};
      case "water_tank_cleaning":
        return {"icon": Icons.water_damage, "image": "assets/services/Water_tank_cleaning.jpg"};
      case "plumber":
        return {"icon": Icons.plumbing, "image": "assets/services/Plumber.jpg"};
      case "tiler":
        return {"icon": Icons.grid_view, "image": "assets/services/Tiler.jpg"};
      case "interior":
        return {"icon": Icons.format_paint, "image": "assets/services/Tiler.jpg"};
      case "exterior":
        return {"icon": Icons.brush, "image": "assets/services/Exterior.jpg"};
      case "electrician":
        return {"icon": Icons.electrical_services, "image": "assets/services/Electrician.jpg"};
      case "solar":
        return {"icon": Icons.wb_sunny, "image": "assets/services/Solar.jpg"};
      case "generators":
        return {"icon": Icons.power, "image": "assets/services/Generators.jpg"};
      case "moving_service":
        return {"icon": Icons.local_shipping, "image": "assets/services/Moving_Service.jpg"};
      case "irrigation":
        return {"icon": Icons.water, "image": "assets/services/Irritation.jpg"};
      case "pest_control":
        return {"icon": Icons.bug_report, "image": "assets/services/Pest_Control.jpg"};
      default:
        return {
          "icon": Icons.build,
          "image": "assets/backgrounds/services.png", // fallback
        };
    }
  }
}
