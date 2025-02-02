import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fradituri/app/modules/notification_subscription/views/notification_subscription_view.dart';
import 'package:fradituri/app/modules/profile/views/profile_view.dart';
import 'package:get/get.dart';

import '../../app/data/services/api_services.dart';
import '../../app/modules/home/controllers/home_controller.dart';
import '../../app/modules/notification_subscription/views/subscription_view.dart';
import '../appColors.dart';
import '../customFont.dart';
import 'home/custom_dropdown.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isTitle;
  const CustomAppBar({super.key, this.title = '', this.isTitle = false});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final CustomDropdownExample dropdown = CustomDropdownExample();
    return Container(
      height: preferredSize.height,
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Added vertical padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          // Menu Icon, Get A Plan Button, Notifications, and Profile Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  if (homeController.chatHistories.isEmpty) {
                    print("Fetching chat history.....................");
                    await homeController.fetchHistory();
                  }

                  print("Chat history count: ${homeController.chatHistories.length}");

                  if (homeController.chatHistories.isNotEmpty) {
                    dropdown.showMenuDropdown(context, homeController.chatHistories);
                  } else {
                    print("No chat history available to show.");
                  }
                },

                child: SvgPicture.asset('assets/images/home/menu_icon.svg'),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(NotificationSubscriptionView());
                    },
                    child: SvgPicture.asset('assets/images/profile/notification_icon.svg'),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      Get.to(ProfileView());
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage: AssetImage("assets/images/profile/profile_avatar.png"),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8), // Added spacing between the two rows
          // Back Icon and Title
          if (isTitle)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text('               ')
              ],
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(140);

}

