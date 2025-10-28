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
      path.moveTo(radius, 0); // Start after top-left corner
      path.lineTo(size.width - radius, 0); // Top edge
      path.arcToPoint(
        Offset(size.width, radius),
        radius: const Radius.circular(radius),
      ); // Top-right corner
      path.lineTo(size.width, size.height - radius); // Right edge
      path.arcToPoint(
        Offset(size.width - radius, size.height),
        radius: const Radius.circular(radius),
      ); // Bottom-right corner
      path.lineTo(0, size.height); // Bottom edge (to the sharp corner)
      path.lineTo(0, radius); // Left edge (from the sharp corner)
      path.arcToPoint(
        const Offset(radius, 0),
        radius: const Radius.circular(radius),
      ); // Top-left corner
      path.close();
    } else {
      // User bubble: top-left, top-right, bottom-left are rounded. Bottom-right is sharp.
      path.moveTo(radius, 0); // Start after top-left corner
      path.lineTo(size.width - radius, 0); // Top edge
      path.arcToPoint(
        Offset(size.width, radius),
        radius: const Radius.circular(radius),
      ); // Top-right corner
      path.lineTo(size.width, size.height); // Right edge (to the sharp corner)
      path.lineTo(radius, size.height); // Bottom edge (from the sharp corner)
      path.arcToPoint(
        Offset(0, size.height - radius),
        radius: const Radius.circular(radius),
      ); // Bottom-left corner
      path.lineTo(0, radius); // Left edge
      path.arcToPoint(
        const Offset(radius, 0),
        radius: const Radius.circular(radius),
      ); // Top-left corner
      path.close();
    }

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
