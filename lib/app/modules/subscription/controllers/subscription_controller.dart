// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/app/models/subscription_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pricing_controller.dart';
import 'payment_controller.dart';

class SubscriptionController extends GetxController {
  final PageController pageController = PageController();
  
  final PricingController pricingController = Get.put(PricingController());
  final PaymentController paymentController = Get.put(PaymentController());

  
  List<SubscriptionPlan> get plans => pricingController.plans;
  RxBool get isLoading => pricingController.isLoading;


  Future<void> initiatePayment(SubscriptionPlan plan) async {
    final planNameLower = plan.planName.toLowerCase();
    if (planNameLower.contains('free')) {
      await paymentController.handleFreeSelection();
      return;
    }

    await paymentController.initiatePaidFlow(plan);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
