import 'dart:convert';

/// Root model for the LLM evaluation/response.
class AIResponseModel {
  final String nextAiMessage;
  final String correctedTranscript;
  final String enhancedTranscript;
  final String conversationSummary;
  final Scores scores;
  final String feedback;

  const AIResponseModel({
    required this.nextAiMessage,
    required this.correctedTranscript,
    required this.enhancedTranscript,
    required this.conversationSummary,
    required this.scores,
    required this.feedback,
  });

  /// Create from a decoded Map (e.g., jsonDecode response).
  factory AIResponseModel.fromMap(Map<String, dynamic> map) {
    return AIResponseModel(
      nextAiMessage: map['nextAiMessage'] as String? ?? '',
      correctedTranscript: map['correctedTranscript'] as String? ?? '',
      enhancedTranscript: map['enhancedTranscript'] as String? ?? '',
      conversationSummary: map['conversationSummary'] as String? ?? '',
      scores: Scores.fromMap(map['scores'] as Map<String, dynamic>),
      feedback: map['feedback'] as String? ?? '',
    );
  }

  /// Create from a JSON string.
  factory AIResponseModel.fromJson(String source) =>
      AIResponseModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  /// Convert to a Map suitable for jsonEncode.
  Map<String, dynamic> toMap() => {
        'nextAiMessage': nextAiMessage,
        'correctedTranscript': correctedTranscript,
        'enhancedTranscript': enhancedTranscript,
        'conversationSummary': conversationSummary,
        'scores': scores.toMap(),
        'feedback': feedback
      };

  /// Convert to a JSON string.
  String toJson() => jsonEncode(toMap());

  /// Immutable updater.
  AIResponseModel copyWith({
    String? nextAiMessage,
    String? correctedTranscript,
    String? enhancedTranscript,
    String? conversationSummary,
    Scores? scores,
  }) {
    return AIResponseModel(
      nextAiMessage: nextAiMessage ?? this.nextAiMessage,
      correctedTranscript: correctedTranscript ?? this.correctedTranscript,
      enhancedTranscript: enhancedTranscript ?? this.enhancedTranscript,
      conversationSummary: conversationSummary ?? this.conversationSummary,
      scores: scores ?? this.scores,
      feedback: feedback
    );
  }

  @override
  String toString() =>
      'AIResponseModel(nextAiMessage: $nextAiMessage, correctedTranscript: $correctedTranscript, '
      'enhancedTranscript: $enhancedTranscript, conversationSummary: $conversationSummary, '
      'scores: $scores)';
}

/// Nested model for scoring dimensions.
class Scores {
  final int fluency;
  final int grammar;
  final int vocabulary;
  final int pronunciation;

  const Scores({
    required this.fluency,
    required this.grammar,
    required this.vocabulary,
    required this.pronunciation,
  });

  factory Scores.fromMap(Map<String, dynamic> map) {
    int _asInt(dynamic v) => (v is int) ? v : int.parse(v.toString());

    return Scores(
      fluency: _asInt(map['fluency']),
      grammar: _asInt(map['grammar']),
      vocabulary: _asInt(map['vocabulary']),
      pronunciation: _asInt(map['pronunciation']),
    );
  }

  factory Scores.fromJson(String source) =>
      Scores.fromMap(jsonDecode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() => {
        'fluency': fluency,
        'grammar': grammar,
        'vocabulary': vocabulary,
        'pronunciation': pronunciation,
      };

  String toJson() => jsonEncode(toMap());

  Scores copyWith({
    int? fluency,
    int? grammar,
    int? vocabulary,
    int? pronunciation,
  }) {
    return Scores(
      fluency: fluency ?? this.fluency,
      grammar: grammar ?? this.grammar,
      vocabulary: vocabulary ?? this.vocabulary,
      pronunciation: pronunciation ?? this.pronunciation,
    );
  }

  @override
  String toString() =>
      'Scores(fluency: $fluency, grammar: $grammar, vocabulary: $vocabulary, pronunciation: $pronunciation)';
}
