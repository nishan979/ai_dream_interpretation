import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final isSecondStep = false.obs;
  final PageController pageController = PageController();

  final selectedAuth = 'Log In'.obs;

  void nextStep() {
    isSecondStep.value = true;
  }

  void selectAuthOption(String option) {
    selectedAuth.value = option;
  }

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
