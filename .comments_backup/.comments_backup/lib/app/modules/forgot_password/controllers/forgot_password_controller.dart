// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  final String _apiUrl = '$baseUrl/auth/password-reset/request/';

  Future<void> sendOtp() async {
    if (emailController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email address.');
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await http.post(
        Uri.parse(_apiUrl),
        body: {'email': emailController.text},
      );

      Get.back();

      if (response.statusCode == 200) {
        Get.toNamed(
          '/verification',
          arguments: {
            'email': emailController.text,
            'next_route': '/new-password',
          },
        );
      } else {
        // You can add more specific error handling here if needed
        // (debug print removed)
        Get.snackbar(
          'Error',
          'Could not send OTP. Please check the email and try again.',
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Could not connect to the server.');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
