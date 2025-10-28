// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeatureListItem extends StatelessWidget {
  final String text;
  final bool isIncluded;

  const FeatureListItem({
    super.key,
    required this.text,
    required this.isIncluded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(
            isIncluded ? Icons.check_circle : Icons.cancel,
            color: isIncluded ? Color(0xFF16ED44) : Color(0xFFE50031),
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
