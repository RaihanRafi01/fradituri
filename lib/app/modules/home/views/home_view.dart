import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/customAppBar.dart';
import '../../../../common/widgets/home/custom_messageInputField.dart';
import '../../../../common/widgets/home/message_bubble.dart';
import '../controllers/chat_controller.dart';
import 'chat_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController()); // Initialize ChatController
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display the last bot message from the chat
              Obx(
                    () => chatController.messages.isNotEmpty
                    ? BotMessage(
                  message: chatController.messages.lastWhere(
                        (msg) => msg['sender'] == 'bot',
                    orElse: () => {'message': 'Hello!'},
                  )['message']!,
                )
                    : const BotMessage(message: 'Hello! How can I assist you today?'),
              ),
              const SizedBox(height: 6.0),
              // Input field
              CustomMessageInputField(
                textController: textController,
                onSend: () {
                  chatController.sendMessage(textController.text); // Add user message
                  textController.clear(); // Clear input
                  Get.to(const ChatView()); // Navigate to ChatView
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
