import 'dart:convert';

class Message {
  final int id;
  final int conversationId;
  final int senderId;
  final String senderType;
  final String message;
  final String type;
  final String? filePath;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderType,
    required this.message,
    required this.type,
    this.filePath,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      conversationId: json['conversation_id'] as int,
      senderId: json['sender_id'] as int,
      senderType: json['sender_type'] ?? "",
      message: json['body'] ?? "",
      type: json['type'] ?? "text",
      filePath: json['file_path'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Conversation {
  final int id;
  final int userId;
  final int serviceProviderId;
  final User user;
  final ServiceProvider serviceProvider;

  Conversation({
    required this.id,
    required this.userId,
    required this.serviceProviderId,
    required this.user,
    required this.serviceProvider,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      userId: json['user_id'],
      serviceProviderId: json['service_provider_id'],
      user: User.fromJson(json['user']),
      serviceProvider: ServiceProvider.fromJson(json['service_provider']),
    );
  }
}

class User {
  final int id;
  final String firstName;
  final String lastName;

  User({required this.id, required this.firstName, required this.lastName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}

class ServiceProvider {
  final int id;
  final int userId;
  final User user;

  ServiceProvider({required this.id, required this.userId, required this.user});

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'],
      userId: json['user_id'],
      user: User.fromJson(json['user']),
    );
  }
}
