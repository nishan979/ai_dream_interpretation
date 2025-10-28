import 'package:ai_dream_interpretation/resources/colors/colors.dart';

import 'package:ai_dream_interpretation/resources/widgets/gradient_border_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected;
  final double? height;
  final double? width;
  final double? textSize;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSelected = false,
    this.height,
    this.width,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GradientBorderBox(
        borderRadius: 6.0.r,
        borderWidth: 2.0.w,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              height: height ?? 40.h,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.buttonGrad2 : Colors.transparent,
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Center(
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      const LinearGradient(
                        colors: [AppColors.borderGrad1, AppColors.borderGrad2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: textSize ?? 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
