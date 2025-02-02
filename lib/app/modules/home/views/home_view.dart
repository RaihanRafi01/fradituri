import 'package:flutter/material.dart';
import 'package:fradituri/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../controllers/chat_controller.dart';
import '../../../../common/widgets/customAppBar.dart';
import '../../../../common/widgets/home/custom_messageInputField.dart';
import '../../../../common/widgets/home/message_bubble.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    homeController.fetchHistory();
    homeController.getUserInformation();
    final ProfileController profileController = Get.put(ProfileController());
    profileController.terms();
    profileController.privacy();
    final ChatController chatController = Get.put(ChatController());
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(isChat: false,),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /*Obx(() => chatController.messages.isNotEmpty
                  ? BotMessage(
                message: chatController.messages.lastWhere(
                      (msg) => msg['sender'] == 'bot',
                  orElse: () => {'message': 'Hello!'},
                )['message']!,
              )
                  : const BotMessage(message: 'Hello! How can I assist you today?'),
              ),*/
                  const BotMessage(message: 'Hello! How can I assist you today?'),
                  const SizedBox(height: 6.0),
                  CustomMessageInputField(
                    textController: textController,
                    onSend: () {
                      chatController.createChat(textController.text); // Create chat first
                      textController.clear();

                    },
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            return chatController.isLoading.value
                ? Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.appColor2,),
              ),
            )
                : const SizedBox.shrink();
          }),
        ],
      )
    );
  }
}
