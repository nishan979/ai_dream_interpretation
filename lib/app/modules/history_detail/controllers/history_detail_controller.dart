// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/app/models/history_item_model.dart';
import 'package:get/get.dart';

class HistoryDetailController extends GetxController {
  
  final historyItem = Rxn<HistoryItem>();

  @override
  void onInit() {
    super.onInit();
    
    if (Get.arguments is HistoryItem) {
      historyItem.value = Get.arguments;
    }
  }
}
