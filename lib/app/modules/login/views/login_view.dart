import 'package:ai_dream_interpretation/resources/colors/colors.dart';
import 'package:ai_dream_interpretation/resources/widgets/gradient_text_field.dart';
import 'package:ai_dream_interpretation/resources/widgets/info_container.dart';
import 'package:ai_dream_interpretation/resources/widgets/primary_button.dart';
import 'package:ai_dream_interpretation/resources/widgets/social_login_button.dart';
import 'package:ai_dream_interpretation/resources/widgets/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const TransparentAppBar(showBackButton: false),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background_image.png', fit: BoxFit.cover),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 85.h),
            child: InfoContainer(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'WELCOME BACK!',
                      style: TextStyle(
                        fontFamily: 'JuliusSansOne',
                        fontSize: 25.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Please log in to your account and start the adventure.',
                      style: TextStyle(fontSize: 10.sp, color: Colors.white),
                    ),
                    SizedBox(height: 30.h),
                    GradientTextField(
                      controller: controller.emailController,
                      labelText: 'EMAIL',
                      hintText: 'Enter your email or phone number',
                    ),
                    SizedBox(height: 20.h),
                    GradientTextField(
                      controller: controller.passwordController,
                      labelText: 'PASSWORD',
                      hintText: 'Enter your password',
                      isPassword: true,
                    ),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: controller.toggleRememberMe,
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.9,
                                    child: Checkbox(
                                      value: controller.rememberMe.value,
                                      onChanged: (val) =>
                                          controller.toggleRememberMe(),
                                      checkColor: Colors.white,
                                      activeColor: AppColors.borderGrad1,
                                      side: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Remember me',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed('/forgot-password');
                            },
                            child: ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) =>
                                  const LinearGradient(
                                    colors: [
                                      AppColors.borderGrad1,
                                      AppColors.borderGrad2,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(
                                    Rect.fromLTWH(
                                      0,
                                      0,
                                      bounds.width,
                                      bounds.height,
                                    ),
                                  ),
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    // 1. Remove the GestureDetector from here
                    PrimaryButton(
                      text: 'Log In',
                      isSelected: true,
                      onPressed: controller.loginWithEmail,
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.white54)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                          child: Text('OR', style: TextStyle(fontSize: 14.sp)),
                        ),
                        const Expanded(child: Divider(color: Colors.white54)),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialLoginButton(
                          iconPath: 'assets/icons/google.svg',
                          // 2. Call the Google Sign-In method from your LoginController
                          onPressed: controller.signInWithGoogle,
                        ),
                        SizedBox(width: 24.w),
                        SocialLoginButton(
                          iconPath: 'assets/icons/apple.svg',
                          onPressed: () {
                            // TODO: Implement Apple Sign-In
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'JuliusSansOne',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/signup');
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              fontFamily: 'JuliusSansOne',
                            ),
                          ),
                        ),
                      ],
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
