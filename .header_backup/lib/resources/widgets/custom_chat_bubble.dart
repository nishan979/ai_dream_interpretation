import 'package:ai_dream_interpretation/resources/colors/colors.dart';
import 'package:ai_dream_interpretation/resources/widgets/bubble_type.dart';
import 'package:ai_dream_interpretation/resources/widgets/chat_bubble_painter.dart';
import 'package:ai_dream_interpretation/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomChatBubble extends StatelessWidget {
  final String text;
  final BubbleType type;
  final bool isPlatinum;

  const CustomChatBubble({
    super.key,
    required this.text,
    required this.type,
    required this.isPlatinum,
  });

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [AppColors.borderGrad1, AppColors.borderGrad2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Align(
      alignment: type == BubbleType.ai
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 0.7.sw),
              child: CustomPaint(
                painter: CustomChatBubblePainter(
                  type: type,
                  gradient: gradient,
                  borderWidth: 2.w,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  constraints: BoxConstraints(maxWidth: 0.7.sw),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            if (type == BubbleType.ai) ...[
              SizedBox(width: 8.w),
              GetBuilder<HomeController>(
                builder: (controller) {
                  return Obx(() {
                    final isPlaying = controller.audioService.isPlayingText(
                      text,
                    );
                    return IconButton(
                      onPressed: isPlatinum
                          ? () => controller.toggleReadAloud(text)
                          : () {
                              Get.snackbar(
                                'Platinum Feature',
                                'Please upgrade to the Platinum plan to use this feature.',
                                mainButton: TextButton(
                                  onPressed: () => Get.toNamed('/subscription'),
                                  child: const Text('Upgrade'),
                                ),
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                      icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.volume_up,
                        color: isPlatinum ? Colors.white : Colors.grey,
                        size: 20.sp,
                      ),
                    );
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
