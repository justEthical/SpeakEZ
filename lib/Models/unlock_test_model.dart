import 'dart:convert';

/// Root Unlock Test Model
class UnlockTest {
  final String id;
  final String purpose;
  final String lessonName;
  final String cefrLevel;
  final QuestionPools questionPools;

  UnlockTest({
    required this.id,
    required this.purpose,
    required this.lessonName,
    required this.cefrLevel,
    required this.questionPools,
  });

  factory UnlockTest.fromJson(Map<String, dynamic> json) {
    return UnlockTest(
      id: json['id'],
      purpose: json['purpose'],
      lessonName: json['lesson_name'],
      cefrLevel: json['cefrLevel'],
      questionPools: QuestionPools.fromJson(json['question_pools']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purpose': purpose,
      'lesson_name': lessonName,
      'cefrLevel': cefrLevel,
      'question_pools': questionPools.toJson(),
    };
  }
}

/// Question Pools (grouped by category)
class QuestionPools {
  final List<Question> vocabulary;
  final List<Question> grammar;
  final List<Question> sentence;
  final List<Question> listening;
  final List<Question> speaking;

  QuestionPools({
    required this.vocabulary,
    required this.grammar,
    required this.sentence,
    required this.listening,
    required this.speaking,
  });

  factory QuestionPools.fromJson(Map<String, dynamic> json) {
    return QuestionPools(
      vocabulary: (json['vocabulary'] as List<dynamic>)
          .map((e) => Question.fromJson(e))
          .toList(),
      grammar: (json['grammar'] as List<dynamic>)
          .map((e) => Question.fromJson(e))
          .toList(),
      sentence: (json['sentence'] as List<dynamic>)
          .map((e) => Question.fromJson(e))
          .toList(),
      listening: (json['listening'] as List<dynamic>)
          .map((e) => Question.fromJson(e))
          .toList(),
      speaking: (json['speaking'] as List<dynamic>)
          .map((e) => Question.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vocabulary': vocabulary.map((e) => e.toJson()).toList(),
      'grammar': grammar.map((e) => e.toJson()).toList(),
      'sentence': sentence.map((e) => e.toJson()).toList(),
      'listening': listening.map((e) => e.toJson()).toList(),
      'speaking': speaking.map((e) => e.toJson()).toList(),
    };
  }
}

/// Question Model (flexible for all types)
class Question {
  final String id;
  final String type; // multipleChoice, fillInTheBlanks, trueFalse, sentenceRearranging, listening, speaking
  final String question;
  final Translation questionTranslation;
  final List<String> options;
  final dynamic answer; // Can be int, String, or List<String>
  final String? audioText; // For listening questions

  Question({
    required this.id,
    required this.type,
    required this.question,
    required this.questionTranslation,
    required this.options,
    required this.answer,
    this.audioText,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      type: json['type'],
      question: json['question'],
      questionTranslation: Translation.fromJson(json['question_translation']),
      options: (json['options'] as List<dynamic>).map((e) => e.toString()).toList(),
      answer: json['answer'],
      audioText: json['audio_text'], // only present in listening
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'question': question,
      'question_translation': questionTranslation.toJson(),
      'options': options,
      'answer': answer,
      if (audioText != null) 'audio_text': audioText,
    };
  }
}

/// Translations for questions
class Translation {
  final String hindi;
  final String japanese;

  Translation({
    required this.hindi,
    required this.japanese,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      hindi: json['Hindi'],
      japanese: json['Japanese'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Hindi': hindi,
      'Japanese': japanese,
    };
  }
}

/// Helper to parse JSON string → UnlockTest
UnlockTest unlockTestFromJson(String str) =>
    UnlockTest.fromJson(json.decode(str));

/// Helper to convert UnlockTest → JSON string
String unlockTestToJson(UnlockTest data) =>
    json.encode(data.toJson());
