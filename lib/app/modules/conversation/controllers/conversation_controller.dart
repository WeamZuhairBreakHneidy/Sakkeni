import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import '../../../data/services/api_service.dart';
import '../models/message.dart';
import 'pusher_service.dart';

class ConversationController extends GetxController {
  var conversations = [].obs;
  var messages = <Message>[].obs;
  var isLoading = false.obs;
  var isMessagesLoading = false.obs;
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  static const String conversationsPath = '/api/conversations';

  PusherService? pusherService;
  final Set<int> _subscribedConversations = {};
  int? _loggedInUserId;

  @override
  void onInit() {
    super.onInit();
    _fetchUserId();
    fetchConversations();
  }

  Future<void> _fetchUserId() async {
    try {
      final response = await ApiService().getApi(url: '/api/my-profile');
      if (response.statusCode == 200 && response.body['status'] == true) {
        _loggedInUserId = response.body['data']['id'];
        debugPrint("✅ Logged-in user ID: $_loggedInUserId");
      } else {
        debugPrint("❌ Failed to fetch user ID: ${response.body}");
        Get.snackbar("Error", "Failed to fetch user profile");
      }
    } catch (e) {
      debugPrint("❌ Error fetching user ID: $e");
      Get.snackbar("Error", "Failed to fetch user profile: $e");
    }
  }

  Future<void> initPusher(int conversationId) async {
    if (_subscribedConversations.contains(conversationId)) return;

    final token = await ApiService().tokenService.token;
    if (token == null || token.isEmpty) {
      debugPrint("❌ No token found, cannot init Pusher");
      Get.snackbar("Error", "Authentication failed. Please log in again.");
      return;
    }

    pusherService = PusherService(authToken: token);

    try {
      await pusherService!.init(
        channelName: "private-conversation.$conversationId",
        onEvent: (event) {
          debugPrint("📩 New event: ${event.eventName} - ${event.data}");
          if ((event.eventName == "NewMessage" || event.eventName == "NewMessageSent") && event.data != null) {
            try {
              final decoded = jsonDecode(event.data);
              final msgJson = decoded['message'] ?? decoded;
              final msg = Message.fromJson(msgJson);

              if (!messages.any((m) => m.id == msg.id)) {
                messages.add(msg);
                debugPrint("✅ Added Pusher message: ${msg.message}");
              }
            } catch (e) {
              debugPrint("❌ Error decoding Pusher event: $e");
            }
          }
        },

      );
      _subscribedConversations.add(conversationId);
      debugPrint("✅ Subscribed to private-conversation.$conversationId");
    } catch (e) {
      debugPrint("❌ Pusher init error: $e");
      String errorMessage = "Unable to receive real-time messages. You can still view and send messages.";
      if (e.toString().contains("Auth value for subscription")) {
        errorMessage = "Permission denied for real-time updates. You can still view and send messages.";
      }
      Get.snackbar(
        "Real-Time Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchConversations() async {
    isLoading.value = true;
    try {
      final response = await ApiService().getApi(url: conversationsPath);
      debugPrint("📥 Conversations response: ${response.body}");
      if (response.statusCode == 200 && response.body['status'] == true) {
        conversations.value = response.body['data'];
      } else {
        Get.snackbar("Error", "Failed to load conversations");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load conversations: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMessages(int conversationId) async {
    isMessagesLoading.value = true;
    try {
      final response = await ApiService().getApi(
        url: "$conversationsPath/$conversationId/messages",
      );

      if (response.statusCode == 200 && response.body['status'] == true) {
        final List data = response.body['data'];
        messages.value = data.map((json) => Message.fromJson(json)).toList();
        await initPusher(conversationId);
      } else {
        Get.snackbar("Error", "Failed to load messages");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load messages: $e");
    } finally {
      isMessagesLoading.value = false;
    }
  }

  Future<void> sendMessage(int conversationId) async {
    if (textController.text.trim().isEmpty) return;
    final text = textController.text.trim();
    textController.clear();

    try {
      final response = await ApiService().postApi(
        url: "$conversationsPath/$conversationId/send-messages",
        body: {"body": text},
      );

      if (response.statusCode == 200 && response.body['status'] == true) {
        final msgJson = response.body['data'];
        final sentMessage = Message.fromJson(msgJson);
        if (!messages.any((m) => m.id == sentMessage.id)) {
          messages.add(sentMessage);
          debugPrint("✅ Added sent message: ${sentMessage.message}");
        }
      } else {
        Get.snackbar("Error", "Failed to send message");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to send message: $e");
    }
  }

  String getOtherParticipantName(Map<String, dynamic> conv) {
    final user = User.fromJson(conv['user']);
    final serviceProvider = ServiceProvider.fromJson(conv['service_provider']);
    if (_loggedInUserId != null && user.id == _loggedInUserId) {
      return "${serviceProvider.user.firstName} ${serviceProvider.user.lastName}";
    }
    return "${user.firstName} ${user.lastName}";
  }

  @override
  void onClose() {
    try {
      pusherService?.disconnect();
    } catch (e) {
      debugPrint("❌ Pusher disconnect error: $e");
    }
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}