// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

// import 'package:ai_dream_interpretation/resources/colors/colors.dart';
// import 'package:ai_dream_interpretation/resources/widgets/bubble_type.dart';
// import 'package:ai_dream_interpretation/resources/widgets/gradient_border_box.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// //enum BubbleType { ai, user }

// class ChatBubble extends StatelessWidget {
//   final String text;
//   final BubbleType type;

//   const ChatBubble({super.key, required this.text, required this.type});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: type == BubbleType.ai
//           ? Alignment.centerLeft
//           : Alignment.centerRight,
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 8.h),
//         child: GradientBorderBox(
//           borderRadius: 16.r,
//           borderWidth: 2.w,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//             constraints: BoxConstraints(maxWidth: 0.7.sw),
//             decoration: BoxDecoration(
//               color: AppColors.cardBg,
//               borderRadius: BorderRadius.circular(16.r),
//             ),
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 14.sp,
//                 height: 1.5,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
