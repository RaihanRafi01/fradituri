import 'dart:convert';

import 'package:get/get.dart';

import '../../../data/services/api_services.dart';

class HomeController extends GetxController {
  final ApiService service = ApiService();
  var chatHistories = <Map<String, String>>[].obs;

  @override
  Future<void> onInit() async {
    await service.fetchAllHistory();
    super.onInit();
  }


  Future<void> fetchHistory() async {
    int retryCount = 0;
    const int maxRetries = 2; // Retry up to 2 times (total 3 attempts)

    while (retryCount <= maxRetries) {
      print('count no: $retryCount');
      try {
        final response = await service.getHistory();

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);

          if (responseData['success'] == true &&
              responseData['chatHistories'] is List) {
            chatHistories.value = List<Map<String, String>>.from(
              (responseData['chatHistories'] as List<dynamic>).map((chat) {
                return {
                  'id': chat['_id'] as String,
                  'name': chat['chat_name'] as String,
                };
              }),
            );
            return; // Success, exit the function
          } else {
            throw Exception('Invalid response format');
          }
        } else {
          throw Exception('Failed with status code: ${response.statusCode}');
        }
      } catch (e) {
        retryCount++;

        if (retryCount > maxRetries) {
          Get.snackbar("Error", "Unable to fetch chat history after multiple attempts.");
        } else {
          await Future.delayed(Duration(seconds: 3)); // Wait 3 seconds before retrying
        }
      }
    }
  }


  Future<void> updateChatName(String chatName, String chatId) async {
    try {
      final response = await service.updateChatName(chatName, chatId);

      print(
          ':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchHistory();
        Get.snackbar('Success!', 'Updated the chat name successfully');
      } else {
        Get.snackbar('Something Went Wrong!', 'Please Try Again Later');
      }
    } catch (e) {
      print('::::::ERROR: $e');
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      final response = await service.deleteChat(chatId);

      print(
          ':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchHistory();
        Get.snackbar('Success!', 'Deleted the successfully');
      } else {
        Get.snackbar('Something Went Wrong!', 'Please Try Again Later');
      }
    } catch (e) {
      print('::::::ERROR: $e');
    }
  }
}
