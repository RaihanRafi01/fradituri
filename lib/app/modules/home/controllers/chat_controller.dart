import 'package:get/get.dart';
import 'dart:convert';
import '../../../data/services/api_services.dart';
import '../views/chat_view.dart';

class ChatController extends GetxController {
  final RxList<Map<String, String>> messages = <Map<String, String>>[].obs;
  final ApiService apiService = ApiService();
  String? chatId; // Store chat ID from API

  Future<void> createChat(String firstMessage) async {
    if (firstMessage.trim().isEmpty) return;

    try {
      final response = await apiService.createChat(firstMessage);

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        chatId = responseData["chatHistory"]["_id"]; // Save chat ID
        final chatContents = responseData["chatHistory"]["chat_contents"];

        print(':::::::::::::::chatId:::::::::::::::::::::$chatId');

        // Ensure proper type casting for the response fields
        messages.assignAll(
          chatContents.map<Map<String, String>>((msg) {
            return {
              'sender': (msg['sent_by'] is String) ? (msg['sent_by'] as String).toLowerCase() : '', // Handle null or unexpected types
              'message': (msg['text_content'] is String) ? (msg['text_content'] as String) : '', // Handle null or unexpected types
            };
          }).toList(),
        );

        Get.to(() => const ChatView()); // Navigate to ChatView
      } else {
        Get.snackbar("Error", "Failed to create chat: ${response.reasonPhrase}");
      }
    } catch (e) {
      print(':::::::::::::::::::::::::::::::::::::::::::::::::ERROR : $e');
      Get.snackbar("Error", "Unable to create chat. Please try again.");
    }
  }



  /// Sends a message to the existing chat
  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty || chatId == null) return;

    messages.add({'sender': 'user', 'message': userMessage});
    final int loadingIndex = messages.length;
    messages.add({'sender': 'bot', 'message': '...'});

    try {
      final response = await apiService.sendMessageToChat(chatId!, userMessage);


      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final chatContents = responseData["chatHistory"]["chat_contents"];
        final botResponse = (chatContents is List && chatContents.isNotEmpty)
            ? chatContents.last["text_content"]
            : "Sorry, I couldn't understand that.";

        messages[loadingIndex] = {'sender': 'bot', 'message': botResponse};
      } else {
        messages[loadingIndex] = {'sender': 'bot', 'message': "Error: ${response.reasonPhrase}"};
      }
    } catch (e) {
      messages[loadingIndex] = {'sender': 'bot', 'message': "Error: Unable to fetch response. Please try again."};
    }
  }

  /// Fetches chat history if a chat exists
  Future<void> fetchChatHistory() async {
    if (chatId == null) return;

    try {
      final response = await apiService.getChatHistory(chatId!);


      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final chatContents = responseData["chatHistory"]["chat_contents"];

        messages.assignAll(chatContents.map<Map<String, String>>((msg) => {
          'sender': msg['sent_by'].toLowerCase(),
          'message': msg['text_content'],
        }).toList());
      }
    } catch (e) {
      Get.snackbar("Error", "Unable to fetch chat history.");
    }
  }
}
