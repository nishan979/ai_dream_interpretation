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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ai_dream_interpretation/utils/ui_utils.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final rememberMe = false.obs;

  final String _apiUrl = '$baseUrl/auth/login/';
  final _storage = const FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  
  void loginWithEmail() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter both email and password.');
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
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      UiUtils.safeDismiss();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _storage.write(key: 'access_token', value: data['access']);
        if (rememberMe.value) {
          await _storage.write(key: 'refresh_token', value: data['refresh']);
        } else {
          await _storage.delete(key: 'refresh_token');
        }

        Get.offAllNamed('/home');
        Get.snackbar('Success', 'Welcome back!');
      } else {
        final responseData = json.decode(response.body);
        final errorMessage =
            responseData['detail'] ?? 'Invalid email or password.';
        Get.snackbar('Login Failed', errorMessage);
      }
    } catch (e) {
      Get.back();
      
      Get.snackbar(
        'Error',
        'Could not connect to the server. Please try again.',
      );
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
        UiUtils.safeDismiss();
        return;
      }
      
      
      UiUtils.safeDismiss();
      Get.offAllNamed('/home');
      Get.snackbar(
        'Success',
        'Successfully signed in as ${googleUser.displayName}!',
      );
    } catch (e) {
      UiUtils.safeDismiss();
      
      Get.snackbar('Error', 'Google Sign-In failed. Please try again.');
    }
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
