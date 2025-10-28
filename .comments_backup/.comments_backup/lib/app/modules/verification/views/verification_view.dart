// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/resources/widgets/circular_back_button.dart';
import 'package:ai_dream_interpretation/resources/widgets/info_container.dart';
import 'package:ai_dream_interpretation/resources/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../controllers/verification_controller.dart';

class VerificationView extends GetView<VerificationController> {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45.w,
      height: 40.h,
      textStyle: TextStyle(
        fontSize: 28.sp,
        color: Colors.white,
        fontWeight: FontWeight.w300,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(120),
        borderRadius: BorderRadius.circular(14.r),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: const Align(
          alignment: Alignment.centerLeft,
          child: CircularBackButton(),
        ),
        titleSpacing: 16.w,
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background_image.png', fit: BoxFit.cover),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 85.h),

                child: InfoContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Text(
                        'VERIFY YOUR EMAIL',
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontFamily: 'JuliusSansOne',
                          fontSize: 25.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Obx(
                        () => Text(
                          'Enter the 4-digit code sent to\n${controller.email.value}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        children: [
                          Pinput(
                            length: 4,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                border: Border.all(color: Colors.white),
                              ),
                            ),
                            onCompleted: (pin) => controller.otp.value = pin,
                          ),
                          SizedBox(width: 5.h),
                          PrimaryButton(
                            text: 'Resend code',
                            isSelected: true,
                            onPressed: controller.resendOtp,

                            height: 28.h,
                            width: 80.w,
                            textSize: 11.sp,
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),
                      Obx(() {
                        // Only show the timer when the button is on cooldown
                        if (!controller.canResend.value) {
                          return Text(
                            'Resend in ${controller.resendCooldown.value}s',
                            style: TextStyle(
                              color: Colors.white.withAlpha(
                                (0.7 * 255).toInt(),
                              ),
                              fontSize: 14.sp,
                            ),
                          );
                        } else {
                          // Otherwise, show an empty space
                          return SizedBox(height: 16.h);
                        }
                      }),

                      SizedBox(height: 16.h),
                      PrimaryButton(
                        text: 'Verify',
                        isSelected: true,
                        onPressed: controller.verifyOtp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
