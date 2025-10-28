// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdController extends GetxController {
  BannerAd? bannerAd;
  final isBannerAdReady = false.obs;

  void loadBanner(String adUnitId) {
    bannerAd?.dispose();
    bannerAd = null;

    bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isBannerAdReady.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          isBannerAdReady.value = false;
          ad.dispose();
        },
      ),
    );

    bannerAd!.load();
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }
}
