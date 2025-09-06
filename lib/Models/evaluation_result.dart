class FeedbackResult {
  final String fluency;
  final String grammar;
  final String vocabulary;
  final String pronunciation;
  final String suggestion;
  final String motivation;

  FeedbackResult({
    required this.fluency,
    required this.grammar,
    required this.vocabulary,
    required this.pronunciation,
    required this.suggestion,
    required this.motivation,
  });

  factory FeedbackResult.fromJson(Map<String, dynamic> json) {
    return FeedbackResult(
      fluency: json['fluency'] ?? '',
      grammar: json['grammar'] ?? '',
      vocabulary: json['vocabulary'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      suggestion: json['suggestion'] ?? '',
      motivation: json['motivation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fluency": fluency,
      "grammar": grammar,
      "vocabulary": vocabulary,
      "pronunciation": pronunciation,
      "suggestion": suggestion,
      "motivation": motivation,
    };
  }
}
