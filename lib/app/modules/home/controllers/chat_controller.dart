import 'package:get/get.dart';

class ChatController extends GetxController {
  // List to manage messages
  final RxList<Map<String, String>> messages = <Map<String, String>>[
    {'sender': 'bot', 'message': "Hello! How can I assist you with your health today?"},
  ].obs;

  // Add a new user message and generate a bot response
  void sendMessage(String userMessage) {
    if (userMessage.trim().isEmpty) return;

    // Add user message
    messages.add({'sender': 'user', 'message': userMessage});

    // Simulate bot response
    final botResponse = _generateBotResponse(userMessage);
    messages.add({'sender': 'bot', 'message': botResponse});
  }

  // Generate a bot response (you can customize this logic)
  String _generateBotResponse(String userMessage) {
    if (userMessage.toLowerCase().contains("hello")) {
      return "Hi! How can I assist you today?";
    } else if (userMessage.toLowerCase().contains("fatigue")) {
      return "I'm sorry to hear that. Make sure to rest well and stay hydrated.";
    } else {
      return "Thank you for sharing. Could you provide more details about your symptoms?";
    }
  }
}
