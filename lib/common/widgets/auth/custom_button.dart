import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../appColors.dart';
import '../../customFont.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isGem;
  final VoidCallback onPressed;
  final Gradient backgroundGradient;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsets padding;
  final bool isEditPage;
  final double width;
  final double height;
  final String svgAsset;

  const CustomButton({
    super.key,
    required this.text,
    this.isGem = false,
    required this.onPressed,
    this.backgroundGradient = const LinearGradient(colors: AppColors.appColor),
    this.borderColor = Colors.transparent,
    this.textColor = Colors.white,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.symmetric(vertical: 5),
    this.isEditPage = false,
    this.width = double.maxFinite,
    this.height = 45,
    this.svgAsset = 'assets/images/profile/gem.svg',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width, // Full-width button
      child: !isEditPage
          ? Ink(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          child: Container(
            alignment: Alignment.center,
            padding: padding,
            child: isGem
                ? textWithIcon()
                : Text(
              text,
              textAlign: TextAlign.center,
              style: h4.copyWith(fontSize: 18, color: textColor),
            ),
          ),
        ),
      )
          : OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor), // Border color
          backgroundColor: Colors.transparent, // No solid background
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: isGem
              ? textWithIcon()
              : Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: textColor),
          ),
        ),
      ),
    );
  }

  Widget textWithIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isGem && svgAsset.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: SvgPicture.asset(
              svgAsset, // SVG asset path
              width: 20.0, // Adjust the size as needed
              height: 20.0, // Adjust the size as needed
            ),
          ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: h4.copyWith(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
