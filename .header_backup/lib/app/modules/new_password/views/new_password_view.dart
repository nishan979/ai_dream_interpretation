import 'package:ai_dream_interpretation/resources/widgets/gradient_text_field.dart';
import 'package:ai_dream_interpretation/resources/widgets/info_container.dart';
import 'package:ai_dream_interpretation/resources/widgets/primary_button.dart';
import 'package:ai_dream_interpretation/resources/widgets/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({super.key});

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
            child: InfoContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'SET NEW PASSWORD',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'JuliusSansOne',
                      fontSize: 25.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Your new password must be different from the previous one',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                  SizedBox(height: 32.h),
                  GradientTextField(
                    controller: controller.passwordController,

                    labelText: 'NEW PASSWORD',
                    hintText: 'Enter new password',
                    isPassword: true,
                  ),
                  SizedBox(height: 24.h),
                  GradientTextField(
                    controller: controller.confirmPasswordController,

                    labelText: 'CONFIRM PASSWORD',
                    hintText: 'Confirm new password',
                    isPassword: true,
                  ),
                  SizedBox(height: 32.h),
                  PrimaryButton(
                    text: 'Confirm',
                    isSelected: true,
                    onPressed: controller.confirmNewPassword,
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
