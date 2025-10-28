import 'dart:convert';
import 'package:ai_dream_interpretation/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NewPasswordController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String _email = '';

  final String _apiUrl = '$baseUrl/auth/password-reset/confirm/';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      _email = Get.arguments['email'] ?? '';
    }
  }

  Future<void> confirmNewPassword() async {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in both password fields.');
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match.');
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
          'email': _email,

          'password': passwordController.text,
          'password2': confirmPasswordController.text,
        },
      );

      Get.back();

      if (response.statusCode == 200) {
        Get.toNamed(
          '/confirmation',
          arguments: {
            'message': 'PASSWORD CHANGED SUCCESSFULLY',
            'final_route': '/login',
          },
        );
      } else {
        final responseData = json.decode(response.body);
        final errorMessage = responseData['message'] ?? 'An error occurred.';
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      Get.back();

      Get.snackbar('Error', 'Could not connect to the server.');
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
