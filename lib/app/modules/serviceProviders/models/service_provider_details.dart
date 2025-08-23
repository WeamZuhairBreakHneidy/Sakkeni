class ServiceProviderDetails {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePicturePath;
  final String address;
  final String phoneNumber;
  final String description;
  final double? rate; // ⭐ Add this
  final List<ServiceProviderService> services;

  ServiceProviderDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePicturePath,
    required this.address,
    required this.phoneNumber,
    required this.description,
    this.rate,
    required this.services,
  });

  factory ServiceProviderDetails.fromJson(Map<String, dynamic> json, String baseUrl) {
    final serviceProviderData = json['service_provider'] ?? {};

    return ServiceProviderDetails(
      id: json['id'],
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      email: json['email'] ?? "",
      profilePicturePath: json['profile_picture_path'] != null
          ? "$baseUrl/${json['profile_picture_path']}"
          : null,
      address: json['address'] ?? "No address available",
      phoneNumber: json['phone_number'] ?? "",
      description: serviceProviderData['description'] ?? "",
      rate: (serviceProviderData['rate'] != null)
          ? double.tryParse(serviceProviderData['rate'].toString())
          : null,
      services: (serviceProviderData['service_provider_services'] ?? [])
          .map<ServiceProviderService>((s) => ServiceProviderService.fromJson(s, baseUrl))
          .toList(),
    );
  }
}

class ServiceProviderService {
  final int id;
  final String serviceName;
  final String availabilityStatus;
  final String? description;

  ServiceProviderService({
    required this.id,
    required this.serviceName,
    required this.availabilityStatus,
    this.description,
  });

  factory ServiceProviderService.fromJson(Map<String, dynamic> json, String baseUrl) {
    return ServiceProviderService(
      id: json['id'],
      serviceName: json['service']?['name'] ?? "Unknown",
      availabilityStatus: json['availability_status']?['name'] ?? "Unknown",
      description: json['description'],
    );
  }
}
