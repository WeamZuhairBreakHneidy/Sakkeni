class ProviderQuote {
  final int id;
  final String jobDescription;
  final String? amount;
  final String? scopeOfWork;
  final String status;
  final String? startDate;
  final DateTime createdAt;
  final User user;
  final Service service;
  final ServiceActivity? serviceActivity;

  ProviderQuote({
    required this.id,
    required this.jobDescription,
    this.amount,
    this.scopeOfWork,
    required this.status,
    this.startDate,
    required this.createdAt,
    required this.user,
    required this.service,
    this.serviceActivity,
  });

  factory ProviderQuote.fromJson(Map<String, dynamic> json) {
    return ProviderQuote(
      id: json['id'],
      jobDescription: json['job_description'] ?? "",
      amount: json['amount']?.toString(),
      scopeOfWork: json['scope_of_work'],
      status: json['status'] ?? "",
      startDate: json['start_date'],
      createdAt: DateTime.parse(json['created_at']),
      user: User.fromJson(json['user']),
      service: Service.fromJson(json['service']),
      serviceActivity: json['service_activity'] != null
          ? ServiceActivity.fromJson(json['service_activity'])
          : null,
    );
  }
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePicturePath;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePicturePath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      email: json['email'] ?? "",
      profilePicturePath: json['profile_picture_path'],
    );
  }
}

class Service {
  final int id;
  final String name;

  Service({required this.id, required this.name});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'] ?? "",
    );
  }
}

class ServiceActivity {
  final int id;
  final int userId;
  final int serviceProviderId;
  final int quoteId;
  final String cost;
  final String status;
  final String startDate;
  final String? estimatedEndDate;
  final String createdAt;
  final String updatedAt;

  ServiceActivity({
    required this.id,
    required this.userId,
    required this.serviceProviderId,
    required this.quoteId,
    required this.cost,
    required this.status,
    required this.startDate,
    this.estimatedEndDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceActivity.fromJson(Map<String, dynamic> json) {
    return ServiceActivity(
      id: json['id'],
      userId: json['user_id'],
      serviceProviderId: json['service_provider_id'],
      quoteId: json['quote_id'],
      cost: json['cost']?.toString() ?? "",
      status: json['status'] ?? "",
      startDate: json['start_date'] ?? "",
      estimatedEndDate: json['estimated_end_date'],
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }
}