class HistoryItem {
  final int id;
  final String text;
  final String interpretation;
  final String questions;
  final String? answers;
  final String ultimateInterpretation;
  final String status;
  final String createdAt;

  HistoryItem({
    required this.id,
    required this.text,
    required this.interpretation,
    required this.questions,
    this.answers,
    required this.ultimateInterpretation,
    required this.status,
    required this.createdAt,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    String? parsedAnswers;
    if (json['answers'] is List && (json['answers'] as List).isNotEmpty) {
      parsedAnswers = (json['answers'] as List).join(', ');
    } else if (json['answers'] is String) {
      parsedAnswers = json['answers'];
    }

    return HistoryItem(
      id: json['id'] ?? 0,
      text: json['text'] ?? 'No dream text found.',
      interpretation: json['interpretation'] ?? '',
      questions: json['questions'] ?? '',
      answers: parsedAnswers,
      ultimateInterpretation: json['ultimate_interpretation'] ?? '',
      status: json['status'] ?? 'unknown',
      createdAt: json['created_at'] ?? '',
    );
  }
}
