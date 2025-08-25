class UserQuote {
  final int id;
  final int userId;
  final int serviceProviderId;
  final int serviceId;
  final String jobDescription;
  final String? amount;
  final String? scopeOfWork;
  final String status;
  final String? startDate;
  final String createdAt;
  final String updatedAt;
  final Service service;
  final ServiceActivity? serviceActivity;

  UserQuote({
    required this.id,
    required this.userId,
    required this.serviceProviderId,
    required this.serviceId,
    required this.jobDescription,
    this.amount,
    this.scopeOfWork,
    required this.status,
    this.startDate,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
    this.serviceActivity,
  });

  factory UserQuote.fromJson(Map<String, dynamic> json) {
    return UserQuote(
      id: json['id'],
      userId: json['user_id'],
      serviceProviderId: json['service_provider_id'],
      serviceId: json['service_id'],
      jobDescription: json['job_description'],
      amount: json['amount'],
      scopeOfWork: json['scope_of_work'],
      status: json['status'],
      startDate: json['start_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      service: Service.fromJson(json['service']),
      serviceActivity: json['service_activity'] != null
          ? ServiceActivity.fromJson(json['service_activity'])
          : null,
    );
  }
}

class Service {
  final int id;
  final int serviceCategoryId;
  final String name;

  Service({
    required this.id,
    required this.serviceCategoryId,
    required this.name,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      serviceCategoryId: json['service_category_id'],
      name: json['name'],
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
      cost: json['cost'],
      status: json['status'],
      startDate: json['start_date'],
      estimatedEndDate: json['estimated_end_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}