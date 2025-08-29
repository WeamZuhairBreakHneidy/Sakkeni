import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:http/http.dart' as http;

class PusherService {
  final PusherChannelsFlutter pusher;
  static const String _backendUrl = 'http://192.168.20.39:8000';
  static const String _pusherApiKey = 'a3b7f8aa8d0d286fc686';
  static const String _pusherCluster = 'eu';
  final String _authToken;

  PusherService({required String authToken})
      : _authToken = authToken,
        pusher = PusherChannelsFlutter.getInstance() {
    debugPrint("🔑 PusherService initialized with token: $_authToken");
  }

  Future<void> init({
    required String channelName,
    required Function(PusherEvent) onEvent,
  }) async {
    try {
      debugPrint("Initializing Pusher for non-encrypted private channel: $channelName");
      await pusher.init(
        apiKey: _pusherApiKey,
        cluster: _pusherCluster,
        onConnectionStateChange: _onConnectionStateChange,
        onError: _onError,
        onSubscriptionSucceeded: _onSubscriptionSucceeded,
        onSubscriptionError: _onSubscriptionError,
        onDecryptionFailure: _onDecryptionFailure,
        onAuthorizer: _onAuthorizer,
      );

      await pusher.connect();

      await pusher.subscribe(
        channelName: channelName,
        onEvent: (event) {
          debugPrint("📩 Pusher event on $channelName: ${event.eventName} - ${event.data}");
          onEvent(event); // pass it back to controller
        },
      );

      debugPrint("✅ Subscribed and listening on $channelName");
    } catch (e, stackTrace) {
      debugPrint("❌ Pusher Init Error: $e\nStackTrace: $stackTrace");
      throw Exception("Failed to initialize Pusher: $e");
    }
  }

  Future<dynamic> _onAuthorizer(String channelName, String socketId, dynamic _) async {
    try {
      debugPrint("📡 Authorizing non-encrypted private channel: $channelName with socket $socketId, token: $_authToken");
      final response = await http.post(
        Uri.parse("$_backendUrl/broadcasting/auth"),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'socket_id': socketId,
          'channel_name': channelName,
        },
      );
      debugPrint("📡 Auth response: ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (!body.containsKey('auth')) {
          throw Exception("Invalid auth response: missing 'auth' field in ${response.body}");
        }
        debugPrint("✅ Auth successful: ${body['auth']}");
        return {'auth': body['auth']};
      } else if (response.statusCode == 403) {
        debugPrint("❌ 403 Forbidden: User does not have permission to access $channelName");
        return {'auth': ''}; // Fallback for non-encrypted private channels
      } else {
        throw Exception("Authorization failed: ${response.statusCode} ${response.body}");
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Authorizer error: $e\nStackTrace: $stackTrace");
      return {'auth': ''}; // Fallback to prevent crash
    }
  }

  void disconnect() {
    pusher.disconnect();
    debugPrint("✅ Pusher disconnected");
  }

  void _onConnectionStateChange(dynamic current, dynamic prev) {
    debugPrint("Pusher Connection: $current");
  }

  void _onError(String message, int? code, dynamic e) {
    debugPrint("Pusher Error: $message, code: $code, e: $e");
  }

  void _onSubscriptionSucceeded(String channelName, dynamic data) {
    debugPrint("✅ Subscribed to $channelName successfully!");
  }

  void _onSubscriptionError(String message, dynamic e) {
    debugPrint("❌ Subscription error: $message, e: $e");
    throw Exception("Subscription failed: $message");
  }

  void _onDecryptionFailure(String event, String reason) {
    debugPrint("❌ Decryption failure on $event: $reason");
  }
}