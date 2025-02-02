import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import '../../../data/services/api_services.dart';

class HomeController extends GetxController {
  final ApiService service = ApiService();
  var isLoading = false.obs; // Reactive loading state
  var chatHistories = <Map<String, String>>[].obs;
  RxString profilePicUrl = ''.obs; // This will store the profile picture URL
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxString usertype = ''.obs;

  @override
  Future<void> onInit() async {
    await service.fetchAllHistory();
    await service.getUserInformation();
    super.onInit();
  }


  Future<void> fetchHistory() async {
    isLoading.value = true; // Show the loading screen
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
      }finally {
        isLoading.value = false; // Hide the loading screen
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


  Future<void> uploadProfileImage(File image) async {
    try {
      final response = await service.uploadProfileImage(image);

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // On success, update the profile image URL in GetX state
        if (data['success']) {
          profilePicUrl.value = data['user']['profileImage'];
          Get.snackbar('Success!', 'Profile image uploaded successfully');
        } else {
          Get.snackbar('Something Went Wrong!', 'Failed to upload the image');
        }
      } else {
        Get.snackbar('Error', 'Something Went Wrong! Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('::::::ERROR: $e');
      Get.snackbar('Error', 'Failed to upload profile image. Please try again.');
    }
  }

  Future<void> getUserInformation() async {
    try {
      final response = await service.getUserInformation();

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          profilePicUrl.value = data['user']['profileImage'];
          userEmail.value = data['user']['email'];
          userName.value = data['user']['name'];
          usertype.value = data['user']['plan'];
        }
      } else {
        print('::::::idk ');
      }
    } catch (e) {
      print('::::::ERROR: $e');
    }
  }


}
