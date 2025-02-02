import 'package:flutter/material.dart';
import 'package:fradituri/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customAppBar.dart';

class TermsPrivacyView extends GetView {
  final bool isTerms;
  const TermsPrivacyView({required this.isTerms, super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    return Scaffold(
      appBar: CustomAppBar(
        title: isTerms
            ? 'Terms & Condition'
            : 'Privacy policy',
        isTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners for the card
              ),
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                    AppColors.listColor // Gradient end color
                    ,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20.0), // Padding inside the card
                child: Text(
                  isTerms?
                  profileController.appTerms.value : profileController.appPrivacy.value,
                  style: h3.copyWith(height: 2, fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ),
          Obx(() {
            return profileController.isLoading.value
                ? Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.appColor2,),
              ),
            )
                : const SizedBox.shrink();
          }),
        ],
      )
    );
  }
}
