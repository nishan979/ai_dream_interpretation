// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ai_dream_interpretation/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends GetxController {
  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    
    await _requestPermissions();

    
    await _tryAutoLogin();
  }

  Future<void> _requestPermissions() async {
    
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _tryAutoLogin() async {
    final refreshToken = await _storage.read(key: 'refresh_token');

    if (refreshToken == null) {
      
      await Future.delayed(const Duration(seconds: 3));
      Get.offNamed('/onboarding');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/token/refresh/'),
        body: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _storage.write(key: 'access_token', value: data['access']);
        
        Get.offAllNamed('/home');
      } else {
        
        Get.offNamed('/onboarding');
      }
    } catch (e) {
      
      Get.offNamed('/onboarding');
    }
  }
}
