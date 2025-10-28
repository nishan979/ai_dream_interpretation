// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/app/modules/auth/controllers/auth_controller.dart';
import 'package:ai_dream_interpretation/app/modules/signup/controllers/signup_controller.dart';
import 'package:ai_dream_interpretation/resources/colors/colors.dart';
import 'package:ai_dream_interpretation/resources/widgets/gradient_text_field.dart';
import 'package:ai_dream_interpretation/resources/widgets/info_container.dart';
import 'package:ai_dream_interpretation/resources/widgets/primary_button.dart';
import 'package:ai_dream_interpretation/resources/widgets/social_login_button.dart';
import 'package:ai_dream_interpretation/resources/widgets/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const TransparentAppBar(),

      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background_image.png', fit: BoxFit.cover),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 85.h),
            child: InfoContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'CREATE AN ACCOUNT',
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontFamily: 'JuliusSansOne',
                      fontSize: 25.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Begin your journey to understanding dreams today.',
                    style: TextStyle(fontSize: 10.sp, color: Colors.white),
                  ),
                  SizedBox(height: 11.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GradientTextField(
                        controller: controller.firstNameController,
                        labelText: 'First Name',
                        hintText: 'First Name',
                        width: 140.w,
                      ),
                      GradientTextField(
                        controller: controller.lastNameController,
                        labelText: 'Last Name',
                        hintText: 'Last Name',
                        width: 140.w,
                      ),
                    ],
                  ),
                  SizedBox(height: 11.h),
                  GradientTextField(
                    controller: controller.emailController,
                    labelText: 'Email',
                    hintText: 'Email',
                  ),
                  SizedBox(height: 11.h),
                  GradientTextField(
                    controller: controller.passwordController,

                    labelText: 'Password',
                    hintText: 'Enter your password',
                    isPassword: true,
                  ),
                  SizedBox(height: 11.h),
                  GradientTextField(
                    controller: controller.confirmPasswordController,

                    labelText: 'Confirm Password',
                    hintText: 'Confirm password',
                    isPassword: true,
                  ),

                  Obx(
                    () => GestureDetector(
                      onTap: controller.toggleAgreeToTerms,
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: 0.9,
                              child: Checkbox(
                                value: controller.agreeToTerms.value,
                                onChanged: (val) =>
                                    controller.toggleAgreeToTerms(),
                                checkColor: Colors.white,
                                activeColor: AppColors.borderGrad1,
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'I agree to the terms and conditions',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // PrimaryButton(
                  //   text: 'Create account',
                  //   isSelected: true,
                  //   onPressed: () {
                  //     Get.toNamed(
                  //       '/verification',
                  //       arguments: {
                  //         'next_route': '/confirmation',
                  //         'message': 'ACCOUNT CREATED SUCCESSFULLY',
                  //         'final_route': '/home',
                  //       },
                  //     );
                  //   },
                  // ),
                  PrimaryButton(
                    text: 'Create account',
                    isSelected: true,
                    // This calls the function in your controller that handles
                    // validation and the API request.
                     onPressed: () async {
    bool success = await Get.find<AuthController>().register(
      firstName: controller.firstNameController.text,
      lastName: controller.lastNameController.text,
      email: controller.emailController.text,
      password: controller.passwordController.text,
      password2: controller.confirmPasswordController.text,
    );
    if (success) {
      Get.toNamed('/verification', arguments: {
        'email': controller.emailController.text,
        'next_route': '/confirmation',
        'message': 'ACCOUNT CREATED SUCCESSFULLY',
        'final_route': '/login'
      });
    }
  },
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.white54)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text('OR', style: TextStyle(fontSize: 14.sp)),
                      ),
                      const Expanded(child: Divider(color: Colors.white54)),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialLoginButton(
                        iconPath: 'assets/icons/google.svg',
                        onPressed: controller.signInWithGoogle,
                      ),
                      SizedBox(width: 24.w),
                      SocialLoginButton(
                        iconPath: 'assets/icons/apple.svg',
                        onPressed: () {},
                      ),
                    ],
                  ),
                  //SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed('/login'),
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
