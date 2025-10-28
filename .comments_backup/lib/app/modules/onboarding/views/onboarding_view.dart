import 'package:ai_dream_interpretation/resources/widgets/info_container.dart';
import 'package:ai_dream_interpretation/resources/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background_image.png', fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Obx(
                      () => InfoContainer(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: _slideTransitionBuilder,

                          child: Text(
                            controller.isSecondStep.value
                                ? 'Understand what your soul is whispering'
                                : 'Unlock the hidden meaning of your dreams',
                            key: ValueKey<bool>(controller.isSecondStep.value),

                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'JuliusSansOne',
                              fontSize: 32.sp,
                              color: Colors.white,
                              height: 1.4,
                              letterSpacing: -1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Obx(() {
                      return controller.isSecondStep.value
                          ? _buildAuthButtons()
                          : _buildGetStartedButton();
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _slideTransitionBuilder(Widget child, Animation<double> animation) {
    final inAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(animation);

    final outAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(animation);

    if (child.key == ValueKey(controller.isSecondStep.value) ||
        child.key == const ValueKey('authBtns') &&
            controller.isSecondStep.value ||
        child.key == const ValueKey('getStartedBtn') &&
            !controller.isSecondStep.value) {
      return ClipRect(
        child: SlideTransition(position: inAnimation, child: child),
      );
    } else {
      return ClipRect(
        child: SlideTransition(position: outAnimation, child: child),
      );
    }
  }

  
  Widget _buildGetStartedButton() {
    return PrimaryButton(
      key: const ValueKey('getStartedBtn'),
      text: 'Get Started',
      isSelected: true,
      onPressed: controller.nextStep,
    );
  }

  
  
  
  
  
  
  

  Widget _buildAuthButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(
          text: 'Log In',
          isSelected: controller.selectedAuth.value == 'Log In',
          onPressed: () {
            controller.selectAuthOption('Log In');
            Get.toNamed('/login');
          },
        ),
        SizedBox(height: 16.h),
        PrimaryButton(
          text: 'Sign Up',
          isSelected: controller.selectedAuth.value == 'Sign Up',
          onPressed: () {
            controller.selectAuthOption('Sign Up');
            Get.toNamed('/signup');
          },
        ),
      ],
    );
  }
}
