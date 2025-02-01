import 'package:flutter/material.dart';
import 'package:fradituri/app/modules/authentication/views/authentication_view.dart';
import 'package:fradituri/app/modules/profile/views/about_view.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/customAppBar.dart';
import '../../../../common/widgets/profile/custom_Listile.dart';
import '../../authentication/controllers/authentication_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthenticationController _controller = Get.put(AuthenticationController());

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
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[700],
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 30),
                      const Text(
                        'Pial',
                        style: TextStyle(
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
                    title: 'xyz@gmail.com',
                    titleColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  CustomListTile(
                    svgIconPath: 'assets/images/profile/call_icon.svg',
                    title: '+88 ****96***',
                    titleColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  CustomListTile(
                    svgIconPath: 'assets/images/profile/about_icon.svg',
                    title: 'About',
                    trailingIcon: Icons.arrow_forward_ios,
                    onTap: () {
                      Get.to(AboutView());
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
                        _controller.isLoading.value = true; // Show loading overlay
                        await _controller.logout();
                        _controller.isLoading.value = false; // Hide loading overlay
                      }
                    },
                  ),
                ],
              ),
            ),

            // Loading Overlay
            if (_controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent background
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              ),
          ],
        );
      }),
    );
  }
}
