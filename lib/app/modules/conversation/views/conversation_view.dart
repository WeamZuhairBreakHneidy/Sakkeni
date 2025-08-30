import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/services/api_endpoints.dart';
import '../controllers/conversation_controller.dart';
import 'messages_view.dart';

class ConversationsView extends GetView<ConversationController> {
  const ConversationsView({super.key});

  String _fullImageUrl(String? path) {
    if (path == null || path.isEmpty || path == "1" || !path.startsWith("storage/")) {
      debugPrint("❌ Invalid image path: $path, using default icon");
      return "";
    }
    return "${ApiEndpoints.baseUrl}/$path";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversations"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.conversations.isEmpty) {
          return Center(
            child: Text("No conversations found",
                style: theme.textTheme.bodyLarge),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.conversations.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (_, index) {
            final conv = controller.conversations[index];
            final participantName = controller.getOtherParticipantName(conv);
            final user = conv["user"];
            final imageUrl = _fullImageUrl(user["profile_picture_path"]);

            return GestureDetector(
              onTap: () {
                Get.to(() => MessagesView(conversationId: conv["id"]));
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28.r,
                        child: imageUrl.isNotEmpty
                            ? ClipOval(
                          child: Image.network(
                            imageUrl,
                            width: 56.r,
                            height: 56.r,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint(
                                  "❌ Image load error for $imageUrl: $error");
                              return const Icon(Icons.person, size: 28);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                          ),
                        )
                            : const Icon(Icons.person, size: 28),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              participantName,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Conversation #${conv['id']}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}