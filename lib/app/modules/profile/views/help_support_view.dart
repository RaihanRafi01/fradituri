import 'package:flutter/material.dart';
import 'package:fradituri/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/auth/custom_button.dart';
import '../../../../common/widgets/customAppBar.dart';


class HelpSupportView extends GetView<ProfileController> {
  HelpSupportView({super.key});

  final emailController = TextEditingController(); // Text controllers
  final problemController = TextEditingController();
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'Help Center',isTitle: true,),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 26),
                  TextField(
                    controller: emailController, // Attach the controller
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type Your Email",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF2E2E2E),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white54, width: 1), // Border when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2), // Border when focused
                      ),
                    ),
                  ),
                  SizedBox(height: 26),
                  // Description TextField
                  TextField(
                    controller: problemController, // Attach the controller
                    style: TextStyle(color: Colors.white),
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF2E2E2E),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white54, width: 1), // Border when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2), // Border when focused
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    width: 100,
                    borderRadius: 10,
                    text: 'SEND',
                    onPressed: (){
                      _validateAndSend(context);
                    },
                  )
                ],
              ),
            ),
          ),
          Obx(() {
            return profileController.isLoading.value
                ? Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.appColor2,),
              ),
            )
                : const SizedBox.shrink();
          }),
        ],
      )
    );
  }

  Future<void> _validateAndSend(context) async {
    final email = emailController.text.trim();
    final problem = problemController.text.trim();

    if (email.isEmpty || problem.isEmpty) {
      _showSnackbar('Error', 'Please fill out all fields');
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackbar('Error', 'Please enter a valid email address');
      return;
    }

    await profileController.helpAndSupport(email, problem);
    Navigator.pop(context);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  void _showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
