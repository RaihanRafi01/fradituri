import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/customAppBar.dart';
import '../../../../common/widgets/home/custom_messageInputField.dart';
import '../../../../common/widgets/home/message_bubble.dart';
import '../controllers/chat_controller.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Obx(
                  () => ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final messageData = chatController.messages[index];
                  if (messageData['sender'] == 'bot') {
                    return BotMessage(message: messageData['message']!);
                  } else {
                    return UserMessage(message: messageData['message']!);
                  }
                },
              ),
            ),
          ),
          CustomMessageInputField(
            textController: textController,
            onSend: () {
              chatController.sendMessage(textController.text); // Add user message
              textController.clear(); // Clear input
            },
          ),
        ],
      ),
    );
  }
}
