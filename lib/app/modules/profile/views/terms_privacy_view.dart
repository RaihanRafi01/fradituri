import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/customAppBar.dart';

class TermsPrivacyView extends GetView {
  final bool isTerms;
  const TermsPrivacyView({required this.isTerms, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: isTerms
            ? 'Terms & Condition'
            : 'Privacy policy',
        isTitle: true,
      ),
      body: Padding(
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
              isTerms
                  ? 'Welcome. By using our services, you agree to abide by the terms and conditions outlined below. These terms govern your access to and use of tools and services, so please review them carefully before proceeding. Provides innovative tools designed to enhance how you capture and manage voice recordings. Our services include voice-to-text transcription and AI-driven summarization, which are intended for lawful, ethical purposes only. You must ensure compliance with applicable laws, including obtaining consent from all participants when recording conversations. CleverTalk disclaims liability for any misuse of its tools.'
                  : 'Welcome. By using our services, you agree to abide by the terms and conditions outlined below. These terms govern your access to and use of tools and services, so please review them carefully before proceeding. Provides innovative tools designed to enhance how you capture and manage voice recordings. Our services include voice-to-text transcription and AI-driven summarization, which are intended for lawful, ethical purposes only. You must ensure compliance with applicable laws, including obtaining consent from all participants when recording conversations. CleverTalk disclaims liability for any misuse of its tools.',
              style: h3.copyWith(height: 2, fontSize: 14, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
