// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ai_dream_interpretation/utils/ui_utils.dart';
import 'package:ai_dream_interpretation/app/models/subscription_plan_model.dart';
import 'package:ai_dream_interpretation/app/modules/auth/controllers/auth_controller.dart';
import 'package:ai_dream_interpretation/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ai_dream_interpretation/app/modules/subscription/widgets/checkout_webview.dart';

class PaymentController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final AuthController _authController = Get.find();

  void _safeClose() => UiUtils.safeDismiss();

  Future<void> handleFreeSelection() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        _safeClose();
        UiUtils.showSnackbar('Authentication Error', 'Please log in again.');
        return;
      }

      
      _authController.userType.value = 'free';
      await _authController.fetchUserDetails();
      _safeClose();
      Get.offAllNamed('/home');
      UiUtils.showSnackbar('Success', 'You are now on the Free plan.');
    } catch (_) {
      _safeClose();
      UiUtils.showSnackbar('Error', 'An unexpected error occurred.');
    }
  }

  Future<void> initiatePaidFlow(SubscriptionPlan plan) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        _safeClose();
        UiUtils.showSnackbar('Authentication Error', 'Please log in again.');
        return;
      }

      final subscriptionType = plan.planName.toLowerCase();

      http.Response response;
      try {
        final uri = Uri.parse('$baseUrl/chatbot/create-checkout-session/');
        final multipart = http.MultipartRequest('POST', uri);
        multipart.fields['subscription_type'] = subscriptionType;
        multipart.headers['Authorization'] = 'Bearer $accessToken';

        final streamed = await multipart.send().timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw TimeoutException(
              'create-checkout-session multipart timed out',
            );
          },
        );

        response = await http.Response.fromStream(streamed);
      } on TimeoutException {
        _safeClose();
        UiUtils.showSnackbar(
          'Error',
          'Payment request timed out. Please try again.',
        );
        return;
      } catch (_) {
        _safeClose();
        UiUtils.showSnackbar(
          'Error',
          'Could not initiate payment. Please try again.',
        );
        return;
      }

      if (response.statusCode != 200) {
        try {
          final bodyStr = response.body.toLowerCase();
          if (bodyStr.contains('invalid') || bodyStr.contains('missing')) {
            try {
              final fallbackResp = await http
                  .post(
                    Uri.parse('$baseUrl/chatbot/create-checkout-session/'),
                    headers: {
                      'Authorization': 'Bearer $accessToken',
                      'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: {'subscription_type': subscriptionType},
                  )
                  .timeout(const Duration(seconds: 15));

              response = fallbackResp;
            } catch (_) {}
          }
        } catch (_) {}
      }

      _safeClose();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String? checkoutUrl;
        if (data is Map<String, dynamic>) {
          checkoutUrl =
              data['sessionId']?.toString() ??
              data['url']?.toString() ??
              data['checkout_url']?.toString();
        } else if (data is String) {
          checkoutUrl = data;
        }

        if (checkoutUrl == null || checkoutUrl.isEmpty) {
          UiUtils.showSnackbar(
            'Error',
            'Payment URL missing from server response.',
          );
          return;
        }

        final uri = Uri.tryParse(checkoutUrl);
        if (uri == null) {
          UiUtils.showSnackbar(
            'Error',
            'Invalid payment URL returned by server.',
          );
          return;
        }

        _safeClose();

        
        
        await Future.delayed(const Duration(milliseconds: 200));

        
        var effectiveUrl = checkoutUrl;
        if (!effectiveUrl.startsWith('http://') &&
            !effectiveUrl.startsWith('https://')) {
          effectiveUrl = 'https://$effectiveUrl';
        }

        final routeFuture =
            Get.to<bool?>(() => CheckoutWebView(url: effectiveUrl)) ??
            Future.value(null);

        final result = await routeFuture.timeout(
          const Duration(seconds: 300),
          onTimeout: () {
            return null;
          },
        );

        if (result == true) {
          
          final accessToken2 = await _storage.read(key: 'access_token');
          if (accessToken2 == null) {
            _safeClose();
            UiUtils.showSnackbar(
              'Authentication Error',
              'Please log in again.',
            );
            return;
          }

          final purchasedType = plan.planName.toString().toLowerCase();
          try {
            final multipart = http.MultipartRequest(
              'PATCH',
              Uri.parse('$baseUrl/auth/login/'),
            );
            multipart.fields['user_type'] = purchasedType;
            multipart.headers['Authorization'] = 'Bearer $accessToken2';

            final streamed = await multipart.send();
            final patchResp = await http.Response.fromStream(streamed);

            if (patchResp.statusCode == 200 || patchResp.statusCode == 201) {
              String message = 'Payment completed successfully.';
              try {
                final parsed = json.decode(patchResp.body);
                message = parsed['message']?.toString() ?? message;
              } catch (_) {}

              
              
              _authController.userType.value = purchasedType;
              await _authController.fetchUserDetails();
              Get.offAllNamed('/home');
              UiUtils.showSnackbar('Success', message);
            } else {
              String backendMessage =
                  'Payment succeeded but could not update your account. Please contact support.';
              try {
                final parsed = json.decode(patchResp.body);
                backendMessage =
                    parsed['message']?.toString() ?? backendMessage;
              } catch (_) {}
              UiUtils.showSnackbar('Error', backendMessage);
            }
          } catch (_) {
            UiUtils.showSnackbar(
              'Error',
              'Payment succeeded but updating account failed.',
            );
          }
        } else {
          UiUtils.showSnackbar('Payment', 'Payment was not completed.');
        }
      } else {
        UiUtils.showSnackbar(
          'Error',
          'Could not initiate payment. Please try again.',
        );
      }
    } catch (_) {
      _safeClose();
      UiUtils.showSnackbar('Error', 'An unexpected error occurred.');
    }
  }
}
