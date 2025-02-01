import 'package:get/get.dart';
import 'dart:convert';
import '../../../data/services/api_services.dart';

class ChatController extends GetxController {
  final RxList<Map<String, String>> messages = <Map<String, String>>[
    {'sender': 'bot', 'message': "Hello! How can I assist you with your health today?"},
  ].obs;

  final ApiService apiService = ApiService(); // Initialize the ApiService

  void sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    // Add user message to the chat
    messages.add({'sender': 'user', 'message': userMessage});

    // Add a placeholder bot message
    final int loadingIndex = messages.length;
    messages.add({'sender': 'bot', 'message': '...'}); // Show "..." while loading

    try {
      // Send message to the API
      final response = await apiService.sendMessage(userMessage);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final botResponse = responseData["response"] ?? "Sorry, I couldn't understand that.";
        messages[loadingIndex] = {'sender': 'bot', 'message': botResponse}; // Replace "..." with actual response
      } else {
        messages[loadingIndex] = {'sender': 'bot', 'message': "Error: ${response.reasonPhrase}"};
      }
    } catch (e) {
      messages[loadingIndex] = {'sender': 'bot', 'message': "Error: Unable to fetch response. Please try again."};
    }
  }
}
