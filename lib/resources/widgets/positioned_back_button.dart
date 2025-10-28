// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/resources/widgets/circular_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionedBackButton extends StatelessWidget {
  final double? top;
  final double? left;
  final double scale;

  const PositionedBackButton({
    super.key,
    this.top,
    this.left,
    this.scale = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    final safeAreaTop = MediaQuery.of(context).padding.top;

    return Positioned(
      top: top ?? (safeAreaTop + 10.h),
      left: left ?? 20.w,
      child: Transform.scale(
        scale: scale,
        child: const CircularBackButton(),
      ),
    );
  }
}