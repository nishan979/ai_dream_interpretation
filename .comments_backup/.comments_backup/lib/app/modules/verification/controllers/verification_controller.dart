// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'dart:async';
import 'dart:convert';
import 'package:ai_dream_interpretation/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class VerificationController extends GetxController {
  final email = ''.obs;
  final otp = ''.obs;
  final Map<String, dynamic> _arguments = {};

  final String _verifyApiUrl = '$baseUrl/auth/verify-otp/';
  final String _resendApiUrl = '$baseUrl/auth/resend-otp/';

  final canResend = false.obs;
  final resendCooldown = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      _arguments.addAll(Get.arguments);
      email.value = Get.arguments['email'] ?? '';
    }
    startCooldownTimer();
  }

  void startCooldownTimer() {
    canResend.value = false;
    resendCooldown.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown.value > 0) {
        resendCooldown.value--;
      } else {
        timer.cancel();
        canResend.value = true;
      }
    });
  }

  Future<void> verifyOtp() async {
    if (otp.value.length < 4) {
      Get.snackbar('Error', 'Please enter the 4-digit code.');
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final response = await http.post(
        Uri.parse(_verifyApiUrl),
        body: {'email': email.value, 'otp': otp.value},
      );
      Get.back();

      if (response.statusCode == 200) {
        _navigateToNextStep();
      } else {
        final responseData = json.decode(response.body);
        final errorMessage = responseData['message'] ?? 'Invalid OTP.';
        Get.snackbar('Verification Failed', errorMessage);
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Could not connect to the server.');
    }
  }

  void _navigateToNextStep() {
    final String? nextRoute = _arguments['next_route'];

    if (nextRoute != null) {
      _arguments['otp'] = otp.value;
      Get.toNamed(nextRoute, arguments: _arguments);
    } else {
      Get.offAllNamed('/home');
    }
  }

  Future<void> resendOtp() async {
    if (!canResend.value) return;

    try {
      final response = await http.post(
        Uri.parse(_resendApiUrl),
        body: {'email': email.value},
      );

      if (response.statusCode == 200) {
        // This is the success snackbar
        Get.snackbar('Success', 'A new OTP has been sent to your email.');
        startCooldownTimer();
      } else {
        // This handles errors from the server
        final responseData = json.decode(response.body);
        final errorMessage =
            responseData['detail'] ?? 'Could not send a new OTP.';
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      // This handles network connection errors
      Get.snackbar('Error', 'Could not connect to the server.');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
