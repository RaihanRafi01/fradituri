import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/widgets/auth/custom_HeaderText.dart';
import '../../../../common/widgets/auth/custom_button.dart';
import '../../../../common/widgets/auth/custom_textField.dart';
import '../controllers/authentication_controller.dart';
import 'verify_o_t_p_view.dart';

class ForgotPasswordView extends GetView<AuthenticationController> {
  ForgotPasswordView({super.key});

  final TextEditingController _emailController = TextEditingController();

  void _handleSendOtp() async {
    String email = _emailController.text.trim();

    // Simple regex to check if email contains '@' and ends with '.com'
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$");

    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your email address');
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      Get.snackbar('Error', 'Please enter a valid email address (e.g., example@example.com)');
      return;
    }

    // Show loading indicator
    controller.isLoading.value = true;

    try {
      // Call API to send OTP
      await controller.checkEmail(email); // Assuming sendOtp is the API method

      // On success, navigate to VerifyOTPView
      // For now, you can navigate like this (adjust if necessary):
      // Get.to(VerifyOTPView());
    } catch (e) {
      // Handle error
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      // Hide loading indicator
      controller.isLoading.value = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    Get.put(AuthenticationController());
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeadertext(
                  header1: "Forgot Password",
                  header2: "Please enter your email address to reset password.",
                ),
                SizedBox(height: 30),
                CustomTextField(
                  label: "Your Email",
                  hint: "Enter Email",
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: 'Send OTP',
                  onPressed: _handleSendOtp,
                ),
              ],
            ),
          ),

          // Loading Indicator
          Obx(() {
            return controller.isLoading.value
                ? Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.appColor2,
                ),
              ),
            )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
