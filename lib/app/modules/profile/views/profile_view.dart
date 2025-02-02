import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/widgets/customAppBar.dart';
import '../../../../common/widgets/profile/custom_Listile.dart';
import '../../authentication/controllers/authentication_controller.dart';
import '../../home/controllers/home_controller.dart';
import 'about_view.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final AuthenticationController _authController = Get.put(AuthenticationController());
    final HomeController _homeController = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(title: 'Profile'),
      body: Obx(() {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Picture and Name
                  Row(
                    children: [
                      // Profile Picture
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: _homeController.profilePicUrl.value.isEmpty
                                ? Colors.white  // White background when no profile picture is set
                                : Colors.transparent,  // Transparent background when profile picture is available
                            backgroundImage: _homeController.profilePicUrl.value.isNotEmpty
                                ? NetworkImage(_homeController.profilePicUrl.value)
                                : null,
                            child: (_homeController.profilePicUrl.value.isEmpty)
                                ? Icon(
                              Icons.person_outline_rounded,
                              color: Colors.black, // Icon color, typically black to be visible on a white background
                              size: 50, // Adjust the icon size as needed
                            )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _pickImage(_homeController),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: SvgPicture.asset('assets/images/profile/edit_pic.svg'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 30),
                      Text(
                        _homeController.userName.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Profile Details
                  CustomListTile(
                    svgIconPath: 'assets/images/profile/email_icon.svg',
                    title: _homeController.userEmail.value,
                    titleColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  CustomListTile(
                    svgIconPath: 'assets/images/profile/about_icon.svg',
                    title: 'About',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTap: () {
                      Get.to(() => AboutView());
                    },
                  ),
                  const SizedBox(height: 16),

                  // Logout Button
                  CustomListTile(
                    svgIconPath: 'assets/images/profile/logout_icon.svg',
                    title: 'Log OUT',
                    titleColor: Colors.red,
                    trailingIcon: Icons.arrow_forward_ios,
                    trailingColor: Colors.red,
                    onTap: () async {
                      bool confirmLogout = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirm Logout"),
                            content: Text("Are you sure you want to log out?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text("Logout", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmLogout == true) {
                        _authController.isLoading.value = true; // Show loading overlay
                        await _authController.logout();
                        _authController.isLoading.value = false; // Hide loading overlay
                      }
                    },
                  ),
                ],
              ),
            ),

            // Loading Overlay
            if (_authController.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              ),
          ],
        );
      }),
    );
  }

  // Pick image from gallery and upload it
  Future<void> _pickImage(HomeController homeController) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Upload the image and update the profile URL
      await homeController.uploadProfileImage(File(image.path));
    }
  }
}
