class FeedbackResult {
  final String fluency;
  final String grammar;
  final String vocabulary;
  final String pronunciation;
  final int overallScore;
  final String suggestion;
  final String motivation;

  FeedbackResult({
    required this.fluency,
    required this.grammar,
    required this.vocabulary,
    required this.pronunciation,
    required this.overallScore,
    required this.suggestion,
    required this.motivation,
  });

  factory FeedbackResult.fromJson(Map<String, dynamic> json) {
    return FeedbackResult(
      fluency: json['fluency'] ?? '',
      grammar: json['grammar'] ?? '',
      vocabulary: json['vocabulary'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      overallScore: json['overall_score'] ?? 0,
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
      "overall_score": overallScore,
      "suggestion": suggestion,
      "motivation": motivation,
    };
  }
}
