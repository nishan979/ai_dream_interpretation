import 'package:ai_dream_interpretation/resources/widgets/gradient_text_field.dart';
import 'package:ai_dream_interpretation/resources/widgets/info_container.dart';
import 'package:ai_dream_interpretation/resources/widgets/primary_button.dart';
import 'package:ai_dream_interpretation/resources/widgets/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TransparentAppBar(),

      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background_image.png', fit: BoxFit.cover),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 85.h),

              child: InfoContainer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'FORGOT PASSWORD?',
                      style: TextStyle(
                        fontFamily: 'JuliusSansOne',
                        fontSize: 25.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Enter your email or phone number to reset your password quickly.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    GradientTextField(
                      controller: controller.emailController,

                      labelText: 'EMAIL',
                      hintText: 'Enter your email or phone number',
                    ),
                    SizedBox(height: 20.h),
                    PrimaryButton(
                      text: 'Send OTP',
                      isSelected: true,
                      onPressed: controller.sendOtp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
