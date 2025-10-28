import 'package:ai_dream_interpretation/resources/widgets/bubble_type.dart';

class ChatMessageModel {
  final String text;
  final BubbleType type;
  final Duration? duration;

  ChatMessageModel({required this.text, required this.type, this.duration});
}
