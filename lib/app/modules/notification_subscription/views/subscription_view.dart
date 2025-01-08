import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common/appColors.dart';
import '../../../../common/customFont.dart';
import '../../../../common/widgets/auth/custom_button.dart';
import '../../../../common/widgets/customAppBar.dart';

class SubscriptionView extends GetView {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Subscription',isTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildPlanCard(
              title: 'Upgrade to Premium',
              features: [
                '15 Days free trial',
                '30 minutes of voice-to-text transcription per month',
                'Basic AI-driven summary generation',
                'Cloud storage for up to 1 GB of voice recordings',
                'Limited access to voice recorder features',
              ],
              price: 'Free',
            ),
            const SizedBox(height: 20),
            _buildPlanCard(
              title: 'Upgrade to Pro Plan',
              features: [
                '5 hours of voice-to-text transcription per month',
                'Advanced AI-driven summaries for meetings, lectures, and brainstorming sessions',
                'Cloud storage for up to 10 GB of recordings',
                'Unlimited voice recorder usage with enhanced audio quality',
                'Access to priority customer support',
              ],
              price: '\$50',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required List<String> features,
    required String price,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.appColor, // Add your gradient colors here
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10), // Match the Card's border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: h4.copyWith(
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.appColor2,
                ),
              ),
              const SizedBox(height: 10),
              ...features.map((feature) {
                return Row(
                  children: [
                    SvgPicture.asset('assets/images/profile/tic_icon.svg'),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          feature,
                          style: h4.copyWith(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
              const SizedBox(height: 20),
              (price == 'Free')
                  ? CustomButton(
                isEditPage: true,
                textColor: Colors.white,
                borderColor: AppColors.txtGray,
                text: price,
                onPressed: () {},
              )
                  : CustomButton(
                isEditPage: true,
                textColor: Colors.white,
                borderColor: AppColors.txtGray,
                text: price,
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
