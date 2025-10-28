import 'package:ai_dream_interpretation/app/models/history_item_model.dart';
import 'package:ai_dream_interpretation/resources/widgets/gradient_border_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final HistoryItem item;

  const HistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final formattedDate = item.createdAt.isNotEmpty
        ? DateFormat('MMMM dd, yyyy').format(DateTime.parse(item.createdAt))
        : 'No date';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: GestureDetector(
        onTap: () {
          Get.toNamed('history-detail', arguments: item);
        },
        child: GradientBorderBox(
          borderRadius: 16.r,
          borderWidth: 1.w,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha((0.25 * 255).toInt()),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dream: "${item.text}"',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                if (item.answers != null && item.answers!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Text(
                    'Your Answer: "${item.answers}"',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withAlpha((0.7 * 255).toInt()),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                
                SizedBox(height: 12.h),
                Text(
                  item.ultimateInterpretation.isNotEmpty
                      ? item.ultimateInterpretation
                      : item.interpretation,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withAlpha((0.8 * 255).toInt()),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withAlpha((0.6 * 255).toInt()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
