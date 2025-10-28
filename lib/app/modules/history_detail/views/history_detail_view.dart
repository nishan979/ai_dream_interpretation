// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/resources/widgets/info_container.dart';
import 'package:ai_dream_interpretation/resources/widgets/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/history_detail_controller.dart';

class HistoryDetailView extends GetView<HistoryDetailController> {
  const HistoryDetailView({super.key});

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
              if (controller.historyItem.value == null) {
                return const Center(
                  child: Text(
                    'No conversation data found.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final item = controller.historyItem.value!;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: InfoContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(title: 'Your Dream', content: item.text),

                      if (item.interpretation.isNotEmpty)
                        _buildSection(
                          title: 'Initial Interpretation',
                          content: item.interpretation,
                        ),
                      if (item.answers != null && item.answers!.isNotEmpty)
                        _buildSection(
                          title: 'Your Answer',
                          content: item.answers!,
                        ),
                      if (item.ultimateInterpretation.isNotEmpty)
                        _buildSection(
                          title: 'Final Interpretation',
                          content: item.ultimateInterpretation,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'JuliusSansOne',
              fontSize: 20.sp,
              color: const Color.fromARGB(255, 0, 234, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white.withAlpha(200),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
