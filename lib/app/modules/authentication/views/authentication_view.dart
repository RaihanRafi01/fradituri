import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fradituri/app/modules/authentication/views/splash_view.dart';
import 'package:fradituri/app/modules/home/views/home_splash_view.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/auth/custom_HeaderText.dart';
import '../../../../common/widgets/auth/custom_button.dart';
import '../../../../common/widgets/auth/custom_textField.dart';
import '../../../../common/widgets/auth/signupWithOther.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../controllers/authentication_controller.dart';
import 'forgot_password_view.dart';
import 'sign_up_view.dart';

class AuthenticationView extends GetView<AuthenticationController> {
  AuthenticationView({super.key});

  final AuthenticationController _controller = Get.put(AuthenticationController());
  //final HomeController homeController = Get.put(HomeController());
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    if (_usernameController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Show loading indicator
    _controller.isLoading.value = true;

    try {
      // Proceed with login logic
      await _controller.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

    } catch (e) {
      // Handle errors
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    } finally {
      // Hide loading indicator
      _controller.isLoading.value = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(

                children: [
                  SizedBox(height: 100,),
                  //Align(alignment: Alignment.center, child: SvgPicture.asset('assets/images/auth/logo.svg')),
                  SizedBox(height: 50,),
                  Align(alignment: Alignment.centerLeft,child: CustomHeadertext(header1: "Login to your account",header2: "welcome back! we’ve missed you.",)),
                  SizedBox(height: 30),
                  CustomTextField(label: "Your Email",hint: "Enter Email",prefixIcon: Icons.email_outlined,controller: _usernameController,),
                  CustomTextField(label: "Password",hint: "Enter Password",prefixIcon: Icons.lock_outline_rounded,isPassword: true,controller: _passwordController,),
                  SizedBox(height: 20,),
                  GestureDetector(
                      onTap: ()=> Get.to(()=> ForgotPasswordView()),
                      child: Align(alignment: Alignment.centerRight,child: Text('Forgot Password?',style: TextStyle(color: Colors.red),))),
                  SizedBox(height: 30,),
                  CustomButton(text: "Login",onPressed: (){
                    _handleLogin();
                  }),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't Have An Account?",style: h4.copyWith(color: AppColors.txtGray2,fontSize: 14),),
                      TextButton(
                        onPressed: () => Get.to(()=> SignUpView()),
                        child: Text("Sign Up",style: h4.copyWith(color: AppColors.clrWhite,fontSize: 16),),
                      ),

                    ],
                  ),
                  //SignupWithOther()
                ],
              ),
            ),
          ),
          Obx(() {
            return _controller.isLoading.value
                ? Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.appColor2,),
              ),
            )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
