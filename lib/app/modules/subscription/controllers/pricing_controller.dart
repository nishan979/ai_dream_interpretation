// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'dart:convert';
import 'package:ai_dream_interpretation/app/models/subscription_plan_model.dart';
import 'package:ai_dream_interpretation/resources/colors/colors.dart';
import 'package:ai_dream_interpretation/utils/ui_utils.dart';
import 'package:ai_dream_interpretation/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PricingController extends GetxController {
  final plans = <SubscriptionPlan>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('$baseUrl/chatbot/pricing/'));

      if (response.statusCode == 200) {
        final dynamic parsed = json.decode(response.body);

        List<dynamic> data;
        if (parsed is List) {
          data = parsed;
        } else if (parsed is Map<String, dynamic>) {
          data = parsed['plans'] ?? parsed['data'] ?? parsed['items'] ?? [];
        } else {
          data = [];
        }

        final mapped = data.map<SubscriptionPlan>((jsonPlan) {
          final planNameRaw = (jsonPlan['user_plan'] ?? '')
              .toString()
              .toLowerCase();

          var planColor = AppColors.freePlanColor;
          var priceId = 'free';
          var buttonText = 'Start for Free';

          if (planNameRaw.contains('premium')) {
            planColor = AppColors.premiumPlanColor;
            priceId = jsonPlan['price_id']?.toString() ?? 'price_premium';
            buttonText = 'Purchase Premium';
          } else if (planNameRaw.contains('platinum')) {
            planColor = AppColors.platinumPlanColor;
            priceId = jsonPlan['price_id']?.toString() ?? 'price_platinum';
            buttonText = 'Start Platinum';
          } else if (planNameRaw.contains('free')) {
            planColor = AppColors.freePlanColor;
            priceId = 'free';
            buttonText = 'Start for Free';
          }

          return SubscriptionPlan.fromJson(
            Map<String, dynamic>.from(jsonPlan),
            planColor: planColor,
            priceId: priceId,
            buttonText: buttonText,
          );
        }).toList();

        plans.value = mapped;
      } else {
        UiUtils.showSnackbar('Error', 'Failed to load subscription plans.');
      }
    } catch (_) {
      UiUtils.showSnackbar('Error', 'Could not connect to the server.');
    } finally {
      isLoading.value = false;
    }
  }
}
