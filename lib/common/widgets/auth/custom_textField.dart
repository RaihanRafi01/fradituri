import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart'; // Ensure you have this package in your `pubspec.yaml`
import '../../../app/modules/home/controllers/home_controller.dart';
import '../../appColors.dart';
import '../../customFont.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final bool readOnly;
  final int maxLine;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final double radius;
  final Color textColor;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.readOnly = false,
    this.maxLine = 1,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.keyboardType,
    this.onTap,
    this.radius = 12,
    this.textColor = AppColors.txtGray2,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    if (!widget.isPassword) {
      _obscureText = false;
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: h4.copyWith(fontSize: 16, fontWeight: FontWeight.bold, color: widget.textColor)),
        const SizedBox(height: 8),
        TextField(
          maxLines: widget.maxLine,
          //cursorColor: AppColors.appColor2,
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: widget.isPassword ? _obscureText : false,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          onTap: widget.onTap,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: h4.copyWith(color: AppColors.clrWhite),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.clrWhite)
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
               // color: AppColors.appColor2,
              ),
              onPressed: _togglePasswordVisibility,
            )
                : (widget.suffixIcon != null
                ? Icon(widget.suffixIcon, color: AppColors.clrWhite)
                : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: const BorderSide(color: AppColors.clrWhite),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: const BorderSide(color: AppColors.clrWhite),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: const BorderSide(color: AppColors.clrWhite, width: 2),
            ),
          ),
        ),
        SizedBox(height: 20,)
      ],
    );
  }
}
