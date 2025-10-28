// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/resources/colors/colors.dart';
import 'package:ai_dream_interpretation/resources/widgets/feature_list_item.dart';
import 'package:ai_dream_interpretation/resources/widgets/gradient_border_box.dart';
import 'package:ai_dream_interpretation/resources/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubscriptionCard extends StatelessWidget {
  final String planName;
  final String price;
  final String description;
  final List<FeatureListItem> features;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Color planColor;

  const SubscriptionCard({
    super.key,
    required this.planName,
    required this.price,
    required this.description,
    required this.features,
    required this.buttonText,
    required this.onButtonPressed,
    required this.planColor,
  });

  @override
  Widget build(BuildContext context) {
    return GradientBorderBox(
      borderRadius: 17.r,
      borderWidth: 2.5.w,
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(17.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                planName,
                style: TextStyle(
                  fontFamily: 'JuliusSansOne',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: planColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                price,
                style: TextStyle(fontSize: 42.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                description,
                style: TextStyle(
                  fontFamily: 'JuliusSansOne',
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                'FEATURES:',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              ...features,

              SizedBox(height: 40.h),
              PrimaryButton(
                text: buttonText,
                isSelected: true,
                onPressed: onButtonPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
