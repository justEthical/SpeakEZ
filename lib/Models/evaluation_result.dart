class EvaluationResult {
  final int score;
  final FeedbackCategory fluency;
  final FeedbackCategory grammar;
  final FeedbackCategory vocabulary;
  final FeedbackCategory pronunciation;
  final String motivation;
  final String suggestion;
  final List<String> correction;

  EvaluationResult({
    required this.score,
    required this.fluency,
    required this.grammar,
    required this.vocabulary,
    required this.pronunciation,
    required this.motivation,
    required this.suggestion,
    required this.correction,
  });

  factory EvaluationResult.fromJson(Map<String, dynamic> json) {
    return EvaluationResult(
      score: json['score'],
      fluency: FeedbackCategory.fromJson(json['fluency']),
      grammar: FeedbackCategory.fromJson(json['grammar']),
      vocabulary: FeedbackCategory.fromJson(json['vocabulary']),
      pronunciation: FeedbackCategory.fromJson(json['pronunciation']),
      motivation: json['motivation'],
      suggestion: json['suggestion'],
      correction: List<String>.from(json['correction']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'fluency': fluency.toJson(),
      'grammar': grammar.toJson(),
      'vocabulary': vocabulary.toJson(),
      'pronunciation': pronunciation.toJson(),
      'motivation': motivation,
      'suggestion': suggestion,
      'correction': correction,
    };
  }
}

class FeedbackCategory {
  final int rating;
  final String feedback;

  FeedbackCategory({
    required this.rating,
    required this.feedback,
  });

  factory FeedbackCategory.fromJson(Map<String, dynamic> json) {
    return FeedbackCategory(
      rating: json['rating'],
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'feedback': feedback,
    };
  }
}
