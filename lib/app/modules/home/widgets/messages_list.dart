// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:ai_dream_interpretation/app/modules/auth/controllers/auth_controller.dart';
import 'package:ai_dream_interpretation/resources/widgets/bubble_type.dart';
import 'package:ai_dream_interpretation/resources/widgets/custom_chat_bubble.dart';
import 'package:ai_dream_interpretation/resources/widgets/upgrade_message.dart';
import 'package:ai_dream_interpretation/resources/widgets/voice_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../controllers/home_controller.dart';

class MessagesList extends GetView<HomeController> {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    final ChatController chatController = Get.find();

    return Obx(
      () => ListView.builder(
        reverse: true,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: chatController.messages.length,
        itemBuilder: (context, index) {
          final message = chatController.messages[index];
          if (message.type == BubbleType.upgrade) {
            return const UpgradeMessage();
          } else if (message.type == BubbleType.voice) {
            return const VoiceMessageBubble();
          } else {
            return CustomChatBubble(
              text: message.text,
              type: message.type,
              isPlatinum: authController.userType.value == 'platinum',
            );
          }
        },
      ),
    );
  }
}
