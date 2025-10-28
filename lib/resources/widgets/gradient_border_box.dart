// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/resources/colors/colors.dart';
import 'package:flutter/material.dart';

class GradientBorderBox extends StatelessWidget {
  final double borderWidth;
  final double borderRadius;
  final List<Color> gradientColors;
  final Widget child;

  const GradientBorderBox({
    super.key,
    required this.child,
    this.borderWidth = 20,
    this.borderRadius = 12,
    this.gradientColors = const [AppColors.borderGrad1, AppColors.borderGrad2],
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(
        borderWidth: borderWidth,
        borderRadius: borderRadius,
        gradientColors: gradientColors,
      ),
      child: child,
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double borderWidth;
  final double borderRadius;
  final List<Color> gradientColors;

  _GradientBorderPainter({
    required this.borderWidth,
    required this.borderRadius,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = LinearGradient(colors: gradientColors).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
