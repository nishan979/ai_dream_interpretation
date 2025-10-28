import 'package:ai_dream_interpretation/resources/widgets/gradient_border_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onSend;
  final VoidCallback onMicPressed;
  final VoidCallback onAttachPressed;
  final bool isTyping;
  final bool isListening;
  final bool isPlatinum;
  const ChatInputBar({
    super.key,
    required this.textController,
    required this.onSend,
    required this.onMicPressed,
    required this.onAttachPressed,
    required this.isTyping,
    required this.isListening,
    required this.isPlatinum,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: GradientBorderBox(
        borderRadius: 12.r,
        borderWidth: 1.w,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(20),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onAttachPressed,
                icon: Icon(
                  Icons.attach_file,
                  color: isPlatinum ? Colors.white : Colors.grey,
                ),
              ),

              IconButton(
                onPressed: onMicPressed, // The mic button calls onMicPressed
                icon: Icon(
                  Icons.mic,
                  color: isListening
                      ? Colors.red
                      : (isPlatinum ? Colors.white : Colors.grey),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: textController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your last dream',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                  onSubmitted: (_) =>
                      onSend(), // Allow sending with keyboard action
                ),
              ),

              IconButton(
                onPressed: onSend, // The send button calls onSend
                icon: const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
