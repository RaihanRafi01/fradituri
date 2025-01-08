import 'package:flutter/material.dart';
import 'package:fradituri/app/modules/profile/views/about_view.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/customAppBar.dart';
import '../../../../common/widgets/profile/custom_Listile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(title: 'Profile',),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture and Name
            Row(children: [
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
            ],),
            const SizedBox(height: 32),
            // Reusable CustomListTile Widgets
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
            CustomListTile(
              svgIconPath: 'assets/images/profile/logout_icon.svg',
              title: 'Log OUT',
              titleColor: Colors.red,
              trailingIcon: Icons.arrow_forward_ios,
              trailingColor: Colors.red,
              onTap: () {
                // Add logout functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
