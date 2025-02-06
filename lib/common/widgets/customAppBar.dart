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
  final bool isChat;
  const CustomAppBar({super.key, this.title = '', this.isTitle = false, this.isChat = true});

  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.put(HomeController());
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
                onTap: () {
                  /*if (homeController.chatHistories.isEmpty) {
                    print("Fetching chat history.....................");
                    await homeController.fetchHistory();
                  }

                  print("Chat history count: ${homeController.chatHistories.length}");

                  if (homeController.chatHistories.isNotEmpty) {
                    dropdown.showMenuDropdown(context, *//*homeController.chatHistories,*//*isChat);
                  } else {
                    print("No chat history available to show.");
                  }*/
                  dropdown.showMenuDropdown(context, /*homeController.chatHistories,*/isChat);
                },

                child: SvgPicture.asset('assets/images/home/menu_icon.svg'),
              ),
              Row(
                children: [
                  /*GestureDetector(
                    onTap: () {
                      Get.to(NotificationSubscriptionView());
                    },
                    child: SvgPicture.asset('assets/images/profile/notification_icon.svg'),
                  ),*/
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      Get.to(ProfileView());
                    },
                    child: Obx(()=>CircleAvatar(
                      radius: 15,
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
                        size: 20, // Adjust the icon size as needed
                      )
                          : null,
                    ),)
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

