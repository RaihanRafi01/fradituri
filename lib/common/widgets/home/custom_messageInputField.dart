import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart'; // Assuming you are using GetX for navigation
import '../../../app/modules/home/views/chat_view.dart';
import '../../appColors.dart';
import '../../customFont.dart'; // Replace with your font styling file

class CustomMessageInputField extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onSend;
  final String hintText;
  final double padding;

  const CustomMessageInputField({
    super.key,
    required this.textController,
    required this.onSend,
    this.padding = 10.0,
    this.hintText = 'Type a new message here',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 60, // Set desired height here
              child: TextField(
                controller: textController,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    borderSide: const BorderSide(
                      color: AppColors.appColor2,
                      width: 1.5,
                    ), // Outline border color and width
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.appColor2,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.appColor2,
                      width: 2,
                    ), // Color when focused
                  ),
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.white60), // Hint style
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16, // Adjust vertical padding to control height
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: onSend, // Trigger onSend function
                      child: SvgPicture.asset(
                        'assets/images/home/send_icon.svg',
                        color: Colors.white, // Adjust color if needed
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
