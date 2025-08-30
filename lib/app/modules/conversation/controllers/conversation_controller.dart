import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
    _loadUserIdFromStorage();
    fetchConversations();
  }

  void _loadUserIdFromStorage() {
    final box = GetStorage();
    _loggedInUserId = box.read('user_id');
    debugPrint("✅ Loaded user_id from storage: $_loggedInUserId");
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
          if ((event.eventName == "NewMessage" ||
              event.eventName == "NewMessageSent") &&
              event.data != null) {
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

  /// ✅ Returns the OTHER participant info (name, photo) in the conversation
  Map<String, dynamic>? getOtherParticipant(Map<String, dynamic> conv) {
    if (_loggedInUserId == null) return null;

    final user = conv['user'];
    final serviceProvider = conv['service_provider']?['user'];

    if (user != null && user['id'] == _loggedInUserId) {
      return serviceProvider;
    }
    return user;
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
