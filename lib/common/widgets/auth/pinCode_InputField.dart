import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../appColors.dart';

class PinCodeInputField extends StatelessWidget {
  final int length;
  final void Function(String) onCompleted;

  const PinCodeInputField({
    super.key,
    this.length = 4,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: length,
      animationType: AnimationType.scale,
      textStyle: const TextStyle(fontSize: 24,color: Colors.black),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: 50,
        fieldWidth: 50,
        activeFillColor: AppColors.clrWhite,
        selectedFillColor: AppColors.clrWhite,
        inactiveFillColor: AppColors.clrWhite,
        activeColor: AppColors.clrWhite,
        selectedColor: AppColors.appColor2 ,
        inactiveColor: AppColors.clrWhite,
      ),
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      enableActiveFill: true,
      onChanged: (value) {
        // Optional: Handle changes if needed
      },
      onCompleted: onCompleted,  // Calls onCompleted callback with the PIN
    );
  }
}
