// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../controllers/ad_controller.dart';

class HomeBannerAd extends GetView<AdController> {
  const HomeBannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isBannerAdReady.value && controller.bannerAd != null) {
        return SizedBox(
          width: controller.bannerAd!.size.width.toDouble(),
          height: controller.bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: controller.bannerAd!),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
