  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:intl/intl.dart';
  import '../controllers/conversation_controller.dart';

  class MessagesView extends StatelessWidget {
    final int conversationId;
    const MessagesView({super.key, required this.conversationId});

    @override
    Widget build(BuildContext context) {
      final controller = Get.find<ConversationController>();
      final focusNode = FocusNode();
      controller.fetchMessages(conversationId);

      // ScrollController for auto-scrolling to newest message
      final ScrollController scrollController = ScrollController();

      // Listen for changes in messages and auto-scroll to bottom after UI rebuild
      ever(controller.messages, (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              0,  // Scroll to bottom (since reverse: true)
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      });

      final theme = Theme.of(context);

      return Scaffold(
        appBar: AppBar(
          title: const Text("Messages"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isMessagesLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.messages.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                return ListView.builder(
                  controller: scrollController,  // Attach controller
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  reverse: true,
                  itemCount: controller.messages.length,
                  itemBuilder: (_, index) {
                    final msg = controller.messages[controller.messages.length - 1 - index];
                    final isMe = msg.senderType.contains("User");
                    final time = DateFormat('hh:mm a').format(msg.createdAt);

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                        constraints: BoxConstraints(maxWidth: 0.7.sw),
                        decoration: BoxDecoration(
                          color: isMe ? theme.colorScheme.primary : Colors.grey.shade200,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.r),
                            topRight: Radius.circular(16.r),
                            bottomLeft: Radius.circular(isMe ? 16.r : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 16.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.message,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontSize: 15.sp,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isMe ? Colors.white70 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: TextField(
                          controller: controller.textController,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type a message...",
                          ),
                          minLines: 1,
                          maxLines: 5,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor: theme.colorScheme.primary,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () => controller.sendMessage(conversationId),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }