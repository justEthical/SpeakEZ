import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_ez/Models/lesson_model.dart';

void main() {
  group('Unified Lesson Model Tests', () {
    test('Should parse regular lesson JSON correctly', () async {
      // Load a regular lesson JSON
      final file = File('assets/lessons/A1/1.json');
      final jsonString = await file.readAsString();
      final jsonMap = jsonDecode(jsonString);
      
      // Parse using unified model
      final lesson = Lesson.fromJson(jsonMap);
      
      // Verify regular lesson properties
      expect(lesson.lessonType, LessonType.regular);
      expect(lesson.lessonIntro, isNotNull);
      expect(lesson.lessonIntro!.vocabulary, isNotEmpty);
      expect(lesson.lessonIntro!.grammarTips, isNotEmpty);
      expect(lesson.questionPools.grammar, isNull);
      expect(lesson.questionPools.vocabulary, isNotEmpty);
      expect(lesson.questionPools.sentence, isNotEmpty);
      expect(lesson.questionPools.listening, isNotEmpty);
      expect(lesson.questionPools.speaking, isNotEmpty);
      
      print('✅ Regular lesson parsed successfully');
      print('Lesson: ${lesson.lessonName}');
      print('Type: ${lesson.lessonType}');
      print('Has intro: ${lesson.lessonIntro != null}');
    });
    
    test('Should parse unlock test JSON correctly', () async {
      // Load an unlock test JSON
      final file = File('assets/lessons/UnlockLevel/Unlock_A2.json');
      final jsonString = await file.readAsString();
      final jsonMap = jsonDecode(jsonString);
      
      // Parse using unified model
      final lesson = Lesson.fromJson(jsonMap);
      
      // Verify unlock test properties
      expect(lesson.lessonType, LessonType.unlockTest);
      expect(lesson.lessonIntro, isNull);
      expect(lesson.purpose, 'LevelUnlockTest');
      expect(lesson.questionPools.grammar, isNotNull);
      expect(lesson.questionPools.grammar!, isNotEmpty);
      expect(lesson.questionPools.vocabulary, isNotEmpty);
      expect(lesson.questionPools.sentence, isNotEmpty);
      expect(lesson.questionPools.listening, isNotEmpty);
      expect(lesson.questionPools.speaking, isNotEmpty);
      
      // Test allQuestions helper
      final allQuestions = lesson.questionPools.allQuestions;
      expect(allQuestions, isNotEmpty);
      expect(
        allQuestions.length,
        lesson.questionPools.vocabulary.length +
        lesson.questionPools.grammar!.length +
        lesson.questionPools.sentence.length +
        lesson.questionPools.listening.length +
        lesson.questionPools.speaking.length
      );
      
      print('✅ Unlock test parsed successfully');
      print('Lesson: ${lesson.lessonName}');
      print('Type: ${lesson.lessonType}');
      print('Has grammar pool: ${lesson.questionPools.grammar != null}');
      print('Total questions: ${allQuestions.length}');
    });
    
    test('Should handle Question translations correctly', () async {
      // Test with unlock test that has Translation objects
      final file = File('assets/lessons/UnlockLevel/Unlock_A2.json');
      final jsonString = await file.readAsString();
      final jsonMap = jsonDecode(jsonString);
      
      final lesson = Lesson.fromJson(jsonMap);
      
      // Check vocabulary questions have translations
      final vocabQuestion = lesson.questionPools.vocabulary.first;
      expect(vocabQuestion.questionTranslation, isNotNull);
      expect(vocabQuestion.questionTranslation!['Hindi'], isNotNull);
      expect(vocabQuestion.questionTranslation!['Japanese'], isNotNull);
      
      print('✅ Translations handled correctly');
    });
  });
}