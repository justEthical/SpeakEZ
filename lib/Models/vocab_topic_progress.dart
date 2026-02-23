class VocabTopicResult {
  final int perfectCount;
  final int incorrectCount;
  final int skippedCount;
  final int totalWords;
  final int completedAt; // milliseconds since epoch

  VocabTopicResult({
    required this.perfectCount,
    required this.incorrectCount,
    required this.skippedCount,
    required this.totalWords,
    required this.completedAt,
  });

  // Short keys to minimize Firestore document size
  factory VocabTopicResult.fromMap(Map<String, dynamic> map) =>
      VocabTopicResult(
        perfectCount: map['p'] ?? 0,
        incorrectCount: map['i'] ?? 0,
        skippedCount: map['s'] ?? 0,
        totalWords: map['t'] ?? 0,
        completedAt: map['c'] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'p': perfectCount,
        'i': incorrectCount,
        's': skippedCount,
        't': totalWords,
        'c': completedAt,
      };
}
