import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../data/services/api_services.dart';

class ProfileController extends GetxController {
  final ApiService service = ApiService();
  var isLoading = false.obs; // Reactive loading state
  RxString appPrivacy = ''.obs;
  RxString appTerms = ''.obs;

  Future<void> helpAndSupport(String email, String problem) async {
    isLoading.value = true; // Show the loading screen
    try {
      final http.Response response =
          await service.helpAndSupport(email, problem);

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        Get.snackbar('Success', 'We Will reach you shortly');
      } else {
        final responseBody = jsonDecode(response.body);
        Get.snackbar('Error', responseBody['message'] ?? 'Sign-up failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      print('Error: $e');
    } finally {
      isLoading.value = false; // Hide the loading screen
    }
  }

  Future<void> privacy() async {
    isLoading.value = true; // Show the loading screen
    try {
      final http.Response response =
      await service.privacy();

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final data = jsonDecode(response.body);
        if (data['success']) {
          appPrivacy.value = data['policy']['content'];
        }
      } else {
        Get.snackbar('Warning', 'Something Went Wrong Please Try Again Latter');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      print('Error: $e');
    } finally {
      isLoading.value = false; // Hide the loading screen
    }
  }

  Future<void> terms() async {
    isLoading.value = true; // Show the loading screen
    try {
      final http.Response response =
      await service.terms();

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final data = jsonDecode(response.body);
        if (data['success']) {
          appTerms.value = data['policy']['content'];
        }
      } else {
        Get.snackbar('Warning', 'Something Went Wrong Please Try Again Latter');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      print('Error: $e');
    } finally {
      isLoading.value = false; // Hide the loading screen
    }
  }

}
