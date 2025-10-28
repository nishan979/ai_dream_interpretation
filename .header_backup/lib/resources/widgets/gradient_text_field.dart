import 'package:ai_dream_interpretation/resources/widgets/gradient_border_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool isPassword;
  final double? width;
    final TextEditingController? controller;


  const GradientTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.isPassword = false,
    this.width,
    this.controller
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText.toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          SizedBox(height: 2.h),
          GradientBorderBox(
            borderRadius: 8.0.r,
            borderWidth: 2.0.w,
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'JuliusSansOne',
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white.withAlpha(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
