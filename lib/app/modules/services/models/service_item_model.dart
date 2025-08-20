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
    // Assign icon and image based on service name
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
    switch (serviceName.toLowerCase()) {
      case "carpenter":
        return {
          "icon": Icons.construction,
          "image": "assets/backgrounds/services.png",
        };
      case "metalwork":
        return {
          "icon": Icons.handyman,
          "image": "assets/backgrounds/services.png",
        };
      case "deep cleaning":
        return {
          "icon": Icons.cleaning_services,
          "image": "assets/backgrounds/services.png",
        };
      case "regular cleaning":
        return {
          "icon": Icons.clean_hands,
          "image": "assets/backgrounds/services.png",
        };
      case "water tank cleaning":
        return {
          "icon": Icons.water_damage,
          "image": "assets/backgrounds/services.png",
        };
      case "plumber":
        return {
          "icon": Icons.plumbing,
          "image": "assets/backgrounds/services.png",
        };
      case "sewage unclogging":
        return {
          "icon": Icons.waves,
          "image": "assets/backgrounds/services.png",
        };
      case "tiler":
        return {
          "icon": Icons.grid_view,
          "image": "assets/backgrounds/services.png",
        };
      case "interior":
        return {
          "icon": Icons.format_paint,
          "image": "assets/backgrounds/services.png",
        };
      case "exterior":
        return {
          "icon": Icons.brush,
          "image": "assets/backgrounds/services.png",
        };
      case "electrician":
        return {
          "icon": Icons.electrical_services,
          "image": "assets/backgrounds/services.png",
        };
      case "solar":
        return {
          "icon": Icons.wb_sunny,
          "image": "assets/backgrounds/services.png",
        };
      case "generators":
        return {
          "icon": Icons.power,
          "image": "assets/backgrounds/services.png",
        };
      case "moving service":
        return {
          "icon": Icons.local_shipping,
          "image": "assets/backgrounds/services.png",
        };
      case "irrigation":
        return {
          "icon": Icons.water,
          "image": "assets/backgrounds/services.png",
        };
      case "pest control":
        return {
          "icon": Icons.bug_report,
          "image": "assets/backgrounds/services.png",
        };
      default:
        return {
          "icon": Icons.build,
          "image": "assets/backgrounds/services.png",
        };
    }
  }
}
