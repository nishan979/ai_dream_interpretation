// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/resources/widgets/history_card.dart';
import 'package:ai_dream_interpretation/resources/widgets/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const TransparentAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background_image.png', fit: BoxFit.cover),
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.historyItems.isEmpty) {
                return Center(
                  child: Text(
                    'No dream history found.',
                    style: TextStyle(fontSize: 18.sp, color: Colors.white70),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: controller.historyItems.length,
                itemBuilder: (context, index) {
                  final item = controller.historyItems[index];
                  return HistoryCard(item: item);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
