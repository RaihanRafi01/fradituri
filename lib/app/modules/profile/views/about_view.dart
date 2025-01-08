import 'package:flutter/material.dart';
import 'package:fradituri/app/modules/profile/views/terms_privacy_view.dart';
import 'package:fradituri/common/widgets/customAppBar.dart';

import 'package:get/get.dart';

import '../../../../common/widgets/profile/custom_Listile.dart';
import 'help_support_view.dart';

class AboutView extends GetView {
  const AboutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'About',isTitle: true,),
      body: Column(
        children: [
          const SizedBox(height: 40),
          CustomListTile(
            svgIconPath: 'assets/images/profile/help_icon.svg',
            title: 'Help Center',
            trailingIcon: Icons.arrow_forward_ios,
            onTap: () {
              Get.to(HelpSupportView());
              // Navigate to About
            },
          ),
          const SizedBox(height: 16),
          CustomListTile(
            svgIconPath: 'assets/images/profile/terms_icon.svg',
            title: 'Terms Of Use',
            trailingIcon: Icons.arrow_forward_ios,
            onTap: () {
              Get.to(TermsPrivacyView(isTerms: true,));
            },
          ),
          const SizedBox(height: 16),
          CustomListTile(
            svgIconPath: 'assets/images/profile/privacy_icon.svg',
            title: 'Privacy Policy',
            trailingIcon: Icons.arrow_forward_ios,
            onTap: () {
              Get.to(TermsPrivacyView(isTerms: false,));
            },
          ),
        ],
      ),
    );
  }
}
