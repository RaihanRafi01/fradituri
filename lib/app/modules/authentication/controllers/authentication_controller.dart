import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fradituri/app/modules/authentication/views/authentication_view.dart';
import 'package:fradituri/app/modules/authentication/views/reset_password_view.dart';
import 'package:fradituri/app/modules/authentication/views/verify_o_t_p_view.dart';
import 'package:fradituri/app/modules/home/views/home_splash_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/widgets/auth/popUpWidget.dart';
import '../../../data/services/api_services.dart';

class AuthenticationController extends GetxController {
  final ApiService _service = ApiService();
  var isLoading = false.obs; // Reactive loading state
  RxBool isResendEnabled = false.obs;
  RxInt remainingSeconds = 30.obs;
  RxBool isCodeCorrect = false.obs;
  String verificationMessage = '';
  late Timer _timer;

  void startTimer() {
    isResendEnabled.value = false;
    remainingSeconds.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _timer.cancel();
        isResendEnabled.value = true;
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }


  // Observable variable to store username
  //final RxString usernameOBS = ''.obs;

  final FlutterSecureStorage _storage =
      FlutterSecureStorage(); // For secure storage

  // Store tokens securely
  Future<void> storeTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> signUp(String email, String password, String name) async {
    isLoading.value = true; // Show the loading screen
    try {
      final http.Response response =
          await _service.signUp(email, password, name);

      print(
          ':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final responseBody = jsonDecode(response.body);

        // Store the tokens securely

        Get.snackbar('Success', 'Account created successfully!');
        Get.offAll(() => AuthenticationView());
      } else {
        final responseBody = jsonDecode(response.body);
        Get.snackbar(
            'Error',
            responseBody['message'] ??
                'Sign-up failed\nPlease Use Different Username');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      print('Error: $e');
    } finally {
      isLoading.value = false; // Hide the loading screen
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true; // Show the loading screen
    try {
      final http.Response response = await _service.login(email, password);

      print(
          ':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final responseBody = jsonDecode(response.body);

        print(
            ':::::::::::::::responseBody:::::::::::::::::::::${responseBody}');

        final accessToken = responseBody['accessToken'];
        final refreshToken = responseBody['refreshToken'];

        print(':::::::::::::::accessToken:::::::::::::::::::::$accessToken');
        print(':::::::::::::::refreshToken:::::::::::::::::::::$refreshToken');

        // Store the tokens securely
        await storeTokens(accessToken, refreshToken);

        // SharedPreferences

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true); // User is logged in

        Get.offAll(HomeSplashView());
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

  Future<void> checkEmail(String email) async {
    isLoading.value = true; // Show the loading screen
    try {
      final http.Response response = await _service.checkEmail(email);

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final responseBody = jsonDecode(response.body);

        print(':::::::::::::::responseBody:::::::::::::::::::::${responseBody}');
        final exists = responseBody['exists'];

        if (exists == true) {
          // Only call sendOtp if exists is true
          await sendOtp(email);
        } else {
          Get.snackbar('Warning', 'Email does not exist');
        }

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


  Future<void> sendOtp(String email) async {
    startTimer();
    isLoading.value = true; // Show the loading screen
    try {
      final http.Response response = await _service.sendOtp(email);

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final responseBody = jsonDecode(response.body);

        print(':::::::::::::::responseBody:::::::::::::::::::::${responseBody}');
        Get.offAll(VerifyOTPView(email: email,));

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

  Future<void> verifyOtp(String email, String otp) async {
    isLoading.value = true; // Show the loading screen
    try {
      final http.Response response = await _service.verifyOtp(email,otp);

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final responseBody = jsonDecode(response.body);

        print(':::::::::::::::responseBody:::::::::::::::::::::${responseBody}');
        Get.offAll(ResetPasswordView(email: email,otp : otp));

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

  Future<void> changePassword(String email,String otp, String newPassword) async {
    isLoading.value = true; // Show the loading screen
    try {
      final http.Response response =
      await _service.changePassword(email, otp, newPassword);

      print(
          ':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201

        // Store the tokens securely

        Get.bottomSheet(
          PasswordChangedBottomSheet(),
          isScrollControlled: false,  // Makes sure the bottom sheet can be custom-sized
          enableDrag: false,
          isDismissible: false
        );

      } else {

      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      print('Error: $e');
    } finally {
      isLoading.value = false; // Hide the loading screen
    }
  }

  Future<void> logout() async {
    isLoading.value = true; // Show the loading screen
    /*try {
      final http.Response response = await _service.logout();

      print(':::::::::::::::RESPONSE:::::::::::::::::::::${response.body.toString()}');
      print(':::::::::::::::CODE:::::::::::::::::::::${response.statusCode}');
      print(':::::::::::::::REQUEST:::::::::::::::::::::${response.request}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server responds with success on code 200 or 201
        final responseBody = jsonDecode(response.body);

        print(':::::::::::::::responseBody:::::::::::::::::::::${responseBody}');
        Get.offAll(AuthenticationView());

      } else {
        final responseBody = jsonDecode(response.body);
        Get.snackbar('Error', responseBody['message'] ?? 'Sign-up failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      print('Error: $e');
    } finally {
      isLoading.value = false; // Hide the loading screen
    }*/
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // User is logged in
    Get.offAll(AuthenticationView());
  }

}
