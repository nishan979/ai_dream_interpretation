// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/resources/colors/colors.dart';
import 'package:ai_dream_interpretation/resources/widgets/gradient_border_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceMessageBubble extends StatelessWidget {
  const VoiceMessageBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: GradientBorderBox(
          borderRadius: 16.r,
          borderWidth: 1.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            width: 0.5.sw, // Make it 50% of screen width
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(Icons.play_arrow, color: Colors.white, size: 24.sp),
                SizedBox(width: 8.w),
                Text(
                  'Voice message',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
