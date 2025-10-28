// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/resources/widgets/info_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/confirmation_controller.dart';

class ConfirmationView extends GetView<ConfirmationController> {
  const ConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background_image.png', fit: BoxFit.cover),
          Center(
            child: InfoContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, color: Colors.white, size: 45.sp),
                  SizedBox(height: 24.h),
                  Obx(
                    () => Text(
                      controller.confirmationMessage.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JuliusSansOne',
                        fontSize: 32.sp,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
