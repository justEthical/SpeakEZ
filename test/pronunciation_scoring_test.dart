import 'package:flutter_test/flutter_test.dart';
import 'package:speak_ez/Services/pronunciation_scoring_service.dart';

void main() {
  group('PronunciationScoringService', () {
    final service = PronunciationScoringService();

    test('normalize removes punctuation and lowers case', () {
      expect(PronunciationScoringService.normalize(' About!! '), 'about');
    });

    test('returns perfect score for exact match', () {
      final result = service.evaluate(targetWord: 'about', transcript: 'about');
      expect(result.score, 100);
      expect(result.band, 'Excellent');
      expect(result.isPass, isTrue);
    });

    test('returns 0 score for empty transcript', () {
      final result = service.evaluate(targetWord: 'about', transcript: '');
      expect(result.score, 0);
      expect(result.feedback, 'No speech detected.');
      expect(result.isPass, isFalse);
    });

    test('returns lower score for mismatch', () {
      final result = service.evaluate(targetWord: 'about', transcript: 'cat');
      expect(result.score < 60, isTrue);
      expect(result.band, 'Try Again');
    });
  });
}
