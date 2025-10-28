import 'dart:convert';


import 'package:ai_dream_interpretation/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final _storage = const FlutterSecureStorage();
  final String _baseUrl = '$baseUrl/auth';
  final userType = 'free'.obs;

  Future<void> fetchUserDetails() async {
    final accessToken = await _storage.read(key: 'access_token');
    if (accessToken == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/details/'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        userType.value = data['user_type'] ?? 'free';
      } else {}
    } catch (e) {
      
    }
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String password2,
  }) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final response = await http.post(
        Uri.parse('$_baseUrl/register/'),
        body: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'password2': password2,
        },
      );
      Get.back();

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Registration successful! Please check your email for an OTP.',
        );
        return true;
      } else {
        final error =
            json.decode(response.body)['message'] ?? 'Registration failed.';
        Get.snackbar('Error', error);
        return false;
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Could not connect to the server.');
      return false;
    }
  }

  
  Future<bool> verifyOtp({required String email, required String otp}) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final response = await http.post(
        Uri.parse('$_baseUrl/verify-otp/'),
        body: {'email': email, 'otp': otp},
      );
      Get.back();

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Email verified successfully!');
        return true;
      } else {
        final error = json.decode(response.body)['message'] ?? 'Invalid OTP.';
        Get.snackbar('Error', error);
        return false;
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Could not connect to the server.');
      return false;
    }
  }

  
  Future<void> login({required String email, required String password}) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login/'),
        body: {'email': email, 'password': password},
      );
      Get.back();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        await _storage.write(key: 'access_token', value: data['access']);
        await _storage.write(key: 'refresh_token', value: data['refresh']);

        await fetchUserDetails();

        Get.offAllNamed('/home');
        Get.snackbar('Success', 'Welcome back!');
      } else {
        final error = json.decode(response.body)['detail'] ?? 'Login failed.';
        Get.snackbar('Error', error);
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Could not connect to the server.');
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
      userType.value = 'free';
      Get.offAllNamed('/home');
      Get.snackbar(
        'Success',
        'Successfully signed in as ${googleUser.displayName}!',
      );
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Google Sign-In failed.');
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await _storage.deleteAll(); 
      userType.value = 'free'; 
      Get.offAllNamed('/login');
    } catch (e) {
      
      Get.snackbar('Error', 'Could not sign out.');
    }
  }
}
