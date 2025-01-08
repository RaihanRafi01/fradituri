import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../appColors.dart';

// Reusable CustomListTile Widget
class CustomListTile extends StatelessWidget {
  final String title;
  final String svgIconPath;
  final Color titleColor;
  final IconData? trailingIcon;
  final Color? trailingColor;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color borderColor; // Added borderColor parameter

  const CustomListTile({
    Key? key,
    required this.title,
    required this.svgIconPath,
    this.titleColor = Colors.white,
    this.trailingIcon,
    this.trailingColor,
    this.onTap,
    this.backgroundColor = const Color(0xFF212121), // Default dark grey
    this.borderColor = Colors.grey , // Default border color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppColors.listColor),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor), // Added border property
      ),
      child: ListTile(
        leading: SvgPicture.asset(svgIconPath),
        title: Text(
          title,
          style: TextStyle(color: titleColor, fontSize: 16),
        ),
        trailing: trailingIcon != null
            ? Icon(trailingIcon, color: trailingColor ?? titleColor)
            : null,
        onTap: onTap,
      ),
    );
  }
}
