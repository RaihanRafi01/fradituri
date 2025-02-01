import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/auth/custom_HeaderText.dart';
import '../../../../common/widgets/auth/custom_button.dart';
import '../../../../common/widgets/auth/custom_textField.dart';
import '../../../../common/widgets/auth/terms_and_conditions_checkbox.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_splash_view.dart';
import '../../home/views/home_view.dart';
import '../controllers/authentication_controller.dart';
import 'authentication_view.dart';
import 'splash_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final AuthenticationController _controller = Get.put(AuthenticationController());
  //final HomeController homeController = Get.put(HomeController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _isChecked = false;
    // Handle checkbox change
  void _onCheckboxChanged(bool isChecked) {
    setState(() {
      _isChecked = isChecked;
    });
  }

  void _handleSignUp() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // Check if any field is empty
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Warning', 'Please fill in all fields');
      return;
    }

    // Validate email format
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Warning', 'Please enter a valid email address');
      return;
    }

    // Check if password is at least 8 characters long
    if (password.length < 8) {
      Get.snackbar('Warning', 'Password must be at least 8 characters long');
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      Get.snackbar('Warning', 'Passwords do not match');
      return;
    }

    // Show loading indicator
    _controller.isLoading.value = true;

    try {
      // Proceed with sign-up logic
      await _controller.signUp(email, password, username);

      // On success, navigate to HomeSplashView (or any other view)
      // Get.offAll(HomeSplashView());
    } catch (e) {
      // Handle errors
      Get.snackbar('Warning', 'An unexpected error occurred: $e');
    } finally {
      // Hide loading indicator
      _controller.isLoading.value = false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
    children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              CustomHeadertext(
                header1: "Create an account",
                header2: "Sign up now to get started on your journey.",
              ),
              SizedBox(height: 30,),
              CustomTextField(
                label: 'User Name',
                hint: 'Enter Name',
                prefixIcon: Icons.person_outline_rounded,
                controller: _usernameController,
              ),
              CustomTextField(
                label: 'Your email',
                hint: 'Enter Email',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
              ),
              CustomTextField(
                label: 'Password',
                hint: 'Enter Password',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                controller: _passwordController,
              ),
              CustomTextField(
                label: 'Confirm Password',
                hint: 'Confirm Password',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                controller: _confirmPasswordController,
              ),
          
              // Replaced Row with the new TermsAndConditionsCheckbox widget
              TermsAndConditionsCheckbox(
                onCheckboxChanged: _onCheckboxChanged,
              ),
          
              SizedBox(height: 20,),
          
              // Sign Up button is only enabled if the checkbox is checked
              CustomButton(
                text: "Sign Up",
                onPressed: _isChecked
                    ? () {
                  _handleSignUp();
                }
                    : () {
                  Get.snackbar(
                    'Error',
                    'Please accept Terms & Conditions & Privacy Policy',
                  );
                },
              ),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Have an Account?",style: h4.copyWith(fontSize: 14,color: AppColors.txtGray2),),
                  TextButton(
                    onPressed: () => Get.to(() => AuthenticationView()),
                    child: Text("Log In",style: h4.copyWith(fontSize: 16,color: AppColors.clrWhite)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
        // Loading Indicator
        Obx(() {
          if (_controller.isLoading.value) {
            return Container(
            color: Colors.black45,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.appColor2,),
            ),
          );
          } else {
            return const SizedBox.shrink();
          }
        }),
        ],
      ),
    );
  }
}
