class ServiceProviderServiceGallery {
  final int id;
  final String imageUrl;

  ServiceProviderServiceGallery({
    required this.id,
    required this.imageUrl,
  });

  factory ServiceProviderServiceGallery.fromJson(Map<String, dynamic> json, String baseUrl) {
    final path = json['image_path'] as String?;
    return ServiceProviderServiceGallery(
      id: json['id'],
      imageUrl: (path != null && path.isNotEmpty) ? "$baseUrl/$path" : "assets/backgrounds/default.png",
    );
  }
}
