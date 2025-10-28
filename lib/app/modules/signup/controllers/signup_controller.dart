// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'dart:convert';

import 'package:ai_dream_interpretation/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class SignUpController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final agreeToTerms = false.obs;

  
  final String _apiUrl = '$baseUrl/auth/register/';
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  void toggleAgreeToTerms() => agreeToTerms.value = !agreeToTerms.value;

  Future<void> createAccountWithEmail() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.');
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match.');
      return;
    }
    if (!agreeToTerms.value) {
      Get.snackbar('Error', 'You must agree to the terms and conditions.');
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      

      final response = await http.post(
        Uri.parse(_apiUrl),
        body: {
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'password2': confirmPasswordController.text,
        },
      );
      Get.back();

      

      final responseData = json.decode(response.body);
      final message = responseData['message']?.toString() ?? '';

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          message.toLowerCase().contains('otp has been sent')) {
        
        Get.toNamed(
          '/verification',
          arguments: {
            'email': emailController.text,
            'next_route': '/confirmation',
            'message': 'ACCOUNT CREATED\nSUCCESSFULLY',
            'final_route': '/login',
          },
        );
      } else {
        
        final errorMessage = message.isNotEmpty
            ? message
            : 'An unknown error occurred.';
        Get.snackbar('Sign-Up Failed', errorMessage);
      }
    } catch (e) {
      Get.back();
      
      Get.snackbar('Error', 'Could not connect to the server. Error: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Get.back();
        return;
      }
      Get.back();
      Get.offAllNamed('/home');
      Get.snackbar('Success', 'Welcome, ${googleUser.displayName}!');
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Google Sign-In failed.');
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
