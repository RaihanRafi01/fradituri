import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/auth/custom_HeaderText.dart';
import '../../../../common/widgets/auth/custom_button.dart';
import '../../../../common/widgets/auth/custom_textField.dart';
import '../../../../common/widgets/auth/popUpWidget.dart';
import '../controllers/authentication_controller.dart';

class ResetPasswordView extends GetView {
  final String email;
  final String otp;
  const ResetPasswordView({super.key,required this.email,required this.otp});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    final AuthenticationController _controller = Get.put(AuthenticationController());

    Future<void> validateAndShowBottomSheet() async {
      String password = passwordController.text.trim();
      String confirmPassword = confirmPasswordController.text.trim();

      if (password.isEmpty || confirmPassword.isEmpty) {
        Get.snackbar(
          "Warning",
          "Both fields are required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      if (password.length < 8) {
        Get.snackbar(
          "Warning",
          "Password must be at least 8 characters long",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      if (password != confirmPassword) {
        Get.snackbar(
          "Warning",
          "Passwords do not match",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      // If validation passes, call the change password method
      await _controller.changePassword(email, otp, confirmPassword);
    }


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeadertext(
              header1: "Reset Password",
              header2: "Enter a new password",
            ),
            const SizedBox(height: 30),
            CustomTextField(
              controller: passwordController,
              label: "Password",
              hint: "Enter Password",
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
            ),
            CustomTextField(
              controller: confirmPasswordController,
              label: "Confirm Password",
              hint: "Confirm Password",
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: "Reset Password",
              onPressed: validateAndShowBottomSheet,
            ),
          ],
        ),
      ),
    );
  }
}
