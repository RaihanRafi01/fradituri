import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/widgets/auth/custom_HeaderText.dart';
import '../../../../common/widgets/auth/custom_button.dart';
import '../../../../common/widgets/auth/custom_textField.dart';
import 'verify_o_t_p_view.dart';

class ForgotPasswordView extends GetView {
  const ForgotPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeadertext(header1: "Forgot Password",header2: "Please enter your email address to reset password.",),
            SizedBox(height: 30,),
            CustomTextField(label: "Your Email", hint: "Enter Email",prefixIcon: Icons.email_outlined,),
            SizedBox(height: 20),
            CustomButton(text: 'Send OTP', onPressed: ()=> Get.to(()=> VerifyOTPView()))
          ],
        ),
      ),
    );
  }
}
