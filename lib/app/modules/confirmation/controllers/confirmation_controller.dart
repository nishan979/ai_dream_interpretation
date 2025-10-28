// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:get/get.dart';

class ConfirmationController extends GetxController {
  final confirmationMessage = 'SUCCESS!'.obs;

  String finalRoute = '/home';

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      confirmationMessage.value = Get.arguments['message'] ?? 'SUCCESS!';
    }

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(finalRoute);
    });
  }
}
