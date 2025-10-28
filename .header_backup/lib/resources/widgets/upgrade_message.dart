import 'package:ai_dream_interpretation/resources/colors/colors.dart';
import 'package:ai_dream_interpretation/resources/widgets/gradient_border_box.dart';
import 'package:ai_dream_interpretation/resources/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpgradeMessage extends StatelessWidget {
  const UpgradeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: GradientBorderBox(
          borderRadius: 16.r,
          borderWidth: 3.w,
          child: Container(
            padding: EdgeInsets.all(16.w),
            constraints: BoxConstraints(maxWidth: 0.7.sw),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upgrade today and enjoy exclusive interpretations, emotion tracking, and a calm, ad-free experience.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16.sp,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16.h),
                PrimaryButton(
                  text: 'View Plan',
                  isSelected: false,
                  onPressed: () {
                    Get.toNamed('/subscription');
                  },
                  height: 40.h,
                  textSize: 14.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
