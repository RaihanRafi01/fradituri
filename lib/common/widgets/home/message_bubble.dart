import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../appColors.dart';

class BotMessage extends StatelessWidget {
  final String message;

  const BotMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 60.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*SvgPicture.asset(
                'assets/images/home/bot_icon.svg',
                width: 30,
                height: 30,
              ),*/
              Image.asset(
                'assets/images/home/bot_icon.png', // Path to your PNG image
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: message == '...' ? Colors.grey : Colors.white, // Dim "..."
                    fontStyle: message == '...' ? FontStyle.italic : FontStyle.normal, // Italicize "..."
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_down_alt_outlined, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.copy_rounded, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class UserMessage extends StatelessWidget {
  final String message;

  const UserMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60.0,top: 10,bottom: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppColors.appColor),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
