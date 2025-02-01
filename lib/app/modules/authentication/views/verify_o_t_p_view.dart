import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/auth/custom_button.dart';
import '../../../../common/widgets/auth/pinCode_InputField.dart';
import '../controllers/authentication_controller.dart';
import 'reset_password_view.dart';

class VerifyOTPView extends StatelessWidget {
  final String email;

  const VerifyOTPView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final AuthenticationController _controller =
        Get.put(AuthenticationController());
    RxString otp = ''.obs;

    _controller.startTimer();
    // TextEditingController to capture the OTP input from the user

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'OTP has been sent to your Email',
                  style: h4.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 20),
                PinCodeInputField(
                  onCompleted: (code) {
                    otp.value = code;
                    // If user completes input, you can directly trigger verification
                    _controller.verifyOtp(email, code);
                  },
                ),
                GetBuilder<AuthenticationController>(
                  builder: (controller) {
                    if (controller.verificationMessage.isNotEmpty) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          controller.verificationMessage,
                          style: TextStyle(
                            color: controller.isCodeCorrect.value
                                ? Colors.green
                                : Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }
                    return SizedBox(); // No message yet
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  borderRadius: 5,
                  width: 150,
                  text: "Verify OTP",
                  onPressed: () {
                    String otp2 =
                        otp.value.trim(); // Capture the OTP entered by the user

                    // Check if OTP is exactly 4 digits
                    if (otp2.length == 4) {
                      // Pass the OTP to the verifyOtp method
                      _controller.verifyOtp(email, otp2);
                    } else {
                      // Optionally, show an error if OTP is not 4 digits
                      Get.snackbar(
                          'Warning', 'Please enter a valid 4-digit OTP');
                    }
                  },
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _controller.formatTime(
                          _controller.remainingSeconds.value,
                        ),
                        style: TextStyle(fontSize: 16, color: AppColors.txtGray2),
                      ),
                      const Text(' | ', style: TextStyle(fontSize: 16)),
                      GestureDetector(
                        onTap: () async {
                          if (_controller.isResendEnabled.value) {
                            await _controller.sendOtp(email);
                          }
                        },
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _controller.isResendEnabled.value
                                ? AppColors.clrWhite
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          // Wrap the loading indicator in Obx
          Obx(() {
            return _controller.isLoading.value
                ? Container(
                    color: Colors.black45,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.appColor2,
                      ),
                    ),
                  )
                : SizedBox(); // Empty widget if not loading
          }),
        ],
      ),
    );
  }
}
