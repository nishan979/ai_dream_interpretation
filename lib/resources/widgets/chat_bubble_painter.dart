// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/resources/colors/colors.dart';
import 'package:ai_dream_interpretation/resources/widgets/bubble_type.dart';
import 'package:flutter/material.dart';

class CustomChatBubblePainter extends CustomPainter {
  final BubbleType type;
  final Gradient gradient;
  final double borderWidth;

  CustomChatBubblePainter({
    required this.type,
    required this.gradient,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = AppColors.cardBg
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = Path();
    const radius = 16.0;

    if (type == BubbleType.ai) {
      path.moveTo(radius, 0); 
      path.lineTo(size.width - radius, 0); 
      path.arcToPoint(
        Offset(size.width, radius),
        radius: const Radius.circular(radius),
      ); 
      path.lineTo(size.width, size.height - radius); 
      path.arcToPoint(
        Offset(size.width - radius, size.height),
        radius: const Radius.circular(radius),
      ); 
      path.lineTo(0, size.height); 
      path.lineTo(0, radius); 
      path.arcToPoint(
        const Offset(radius, 0),
        radius: const Radius.circular(radius),
      ); 
      path.close();
    } else {
      
      path.moveTo(radius, 0); 
      path.lineTo(size.width - radius, 0); 
      path.arcToPoint(
        Offset(size.width, radius),
        radius: const Radius.circular(radius),
      ); 
      path.lineTo(size.width, size.height); 
      path.lineTo(radius, size.height); 
      path.arcToPoint(
        Offset(0, size.height - radius),
        radius: const Radius.circular(radius),
      ); 
      path.lineTo(0, radius); 
      path.arcToPoint(
        const Offset(radius, 0),
        radius: const Radius.circular(radius),
      ); 
      path.close();
    }

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
