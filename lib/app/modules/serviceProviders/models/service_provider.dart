class ServiceProvider {
  final int id; // user id
  final int serviceProviderId; // service_provider.id
  final String firstName;
  final String lastName;
  final String address;
  final String? profilePicturePath;
  final String description;

  ServiceProvider({
    required this.id,
    required this.serviceProviderId,
    required this.firstName,
    required this.lastName,
    required this.address,
    this.profilePicturePath,
    required this.description,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json, String baseUrl) {
    return ServiceProvider(
      id: json['id'] ?? 0,
      serviceProviderId: json['service_provider']?['id'] ?? 0,
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      address: json['address'] ?? "No address available",
      profilePicturePath: json['profile_picture_path'] != null
          ? "$baseUrl/${json['profile_picture_path']}"
          : null,
      description: json['service_provider']?['description'] ?? "",
    );
  }
}
