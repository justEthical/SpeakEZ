class PronunciationScoreResult {
  final double score;
  final String feedback;
  final String normalizedTarget;
  final String normalizedTranscript;

  const PronunciationScoreResult({
    required this.score,
    required this.feedback,
    required this.normalizedTarget,
    required this.normalizedTranscript,
  });

  String get band {
    if (score >= 90) return 'Excellent';
    if (score >= 75) return 'Good';
    if (score >= 60) return 'Needs Work';
    return 'Try Again';
  }

  bool get isPass => score >= 75;
}

class PronunciationScoringService {
  static String normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z\\s]'), ' ')
        .replaceAll(RegExp(r'\\s+'), ' ')
        .trim();
  }

  PronunciationScoreResult evaluate({
    required String targetWord,
    required String transcript,
  }) {
    final normalizedTarget = normalize(targetWord);
    final normalizedTranscript = normalize(transcript);

    if (normalizedTranscript.isEmpty) {
      return PronunciationScoreResult(
        score: 0,
        feedback: 'No speech detected.',
        normalizedTarget: normalizedTarget,
        normalizedTranscript: normalizedTranscript,
      );
    }

    final distance = _levenshtein(normalizedTarget, normalizedTranscript);
    final maxLen =
        normalizedTarget.length > normalizedTranscript.length
            ? normalizedTarget.length
            : normalizedTranscript.length;
    final similarity = maxLen == 0 ? 0.0 : (1 - (distance / maxLen));
    final score = (similarity * 100).clamp(0, 100).toDouble();

    String feedback;
    if (normalizedTranscript[0] != normalizedTarget[0]) {
      feedback = 'Opening sound needs correction.';
    } else if ((normalizedTarget.length - normalizedTranscript.length).abs() >=
        3) {
      feedback = 'Missing or extra sounds.';
    } else {
      feedback = 'Stress and syllable clarity needs work.';
    }

    return PronunciationScoreResult(
      score: score,
      feedback: feedback,
      normalizedTarget: normalizedTarget,
      normalizedTranscript: normalizedTranscript,
    );
  }

  int _levenshtein(String a, String b) {
    final m = a.length;
    final n = b.length;

    if (m == 0) return n;
    if (n == 0) return m;

    final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
    for (var i = 0; i <= m; i++) {
      dp[i][0] = i;
    }
    for (var j = 0; j <= n; j++) {
      dp[0][j] = j;
    }

    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        final deletion = dp[i - 1][j] + 1;
        final insertion = dp[i][j - 1] + 1;
        final substitution = dp[i - 1][j - 1] + cost;

        var min = deletion;
        if (insertion < min) min = insertion;
        if (substitution < min) min = substitution;
        dp[i][j] = min;
      }
    }

    return dp[m][n];
  }
}
