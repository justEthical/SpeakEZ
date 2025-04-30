class Lesson {
  final String lessonName;
  final String purpose;
  final CEFRLevel cefrLevel;
  final List<Question> questions;

  Lesson({
    required this.lessonName,
    required this.purpose,
    required this.questions,
    required this.cefrLevel,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonName: json['lesson_name'],
      purpose: json['purpose'],
      cefrLevel: CEFRLevelExtension.fromString(json['cefrLevel']),
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'lesson_name': lessonName,
    'purpose': purpose,
    'cefrLevel': cefrLevel.name,
    'questions': questions.map((q) => q.toJson()).toList(),
  };
}

// Base question class
class Question {
  final String type;
  final String question;
  final List<dynamic> options;
  final dynamic correctAnswer;

  Question({
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: json['type'],
      question: json['question'],
      options: json['options'],
      correctAnswer: json['correct_answer'] ?? json['correct_answers'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'question': question,
    'options': options,
    'correct_answer': correctAnswer,
  };
}

enum QuestionType {
  fillInTheBlanks,
  sentenceCorrection,
  synonymsMatching,
  multipleChoice,
  trueFalse,
  listening,
  speaking,
  sentenceRearranging,
  shortAnswer,
}

extension QuestionTypeExtension on QuestionType {
  String get name {
    switch (this) {
      case QuestionType.fillInTheBlanks:
        return 'fill_in_the_blanks';
      case QuestionType.sentenceCorrection:
        return 'sentence_correction';
      case QuestionType.synonymsMatching:
        return 'synonyms_matching';
      case QuestionType.multipleChoice:
        return 'multiple_choice';
      case QuestionType.trueFalse:
        return 'true_false';
      case QuestionType.listening:
        return 'listening';
      case QuestionType.speaking:
        return 'speaking';
      case QuestionType.sentenceRearranging:
        return 'sentence_rearranging';
      case QuestionType.shortAnswer:
        return 'short_answer';
    }
  }

  static QuestionType fromString(String value) {
    switch (value) {
      case 'fill_in_the_blanks':
        return QuestionType.fillInTheBlanks;
      case 'sentence_correction':
        return QuestionType.sentenceCorrection;
      case 'synonyms_matching':
        return QuestionType.synonymsMatching;
      case 'multiple_choice':
        return QuestionType.multipleChoice;
      case 'true_false':
        return QuestionType.trueFalse;
      case 'listening':
        return QuestionType.listening;
      case 'speaking':
        return QuestionType.speaking;
      case 'sentence_rearranging':
        return QuestionType.sentenceRearranging;
      case 'short_answer':
        return QuestionType.shortAnswer;
      default:
        throw ArgumentError('Unknown question type: $value');
    }
  }
}

enum CEFRLevel { A1, A2, B1, B2, C1, C2 }

extension CEFRLevelExtension on CEFRLevel {
  String get name {
    switch (this) {
      case CEFRLevel.A1:
        return 'A1';
      case CEFRLevel.A2:
        return 'A2';
      case CEFRLevel.B1:
        return 'B1';
      case CEFRLevel.B2:
        return 'B2';
      case CEFRLevel.C1:
        return 'C1';
      case CEFRLevel.C2:
        return 'C2';
    }
  }

  static CEFRLevel fromString(String value) {
    switch (value) {
      case 'A1':
        return CEFRLevel.A1;
      case 'A2':
        return CEFRLevel.A2;
      case 'B1':
        return CEFRLevel.B1;
      case 'B2':
        return CEFRLevel.B2;
      case 'C1':
        return CEFRLevel.C1;
      case 'C2':
        return CEFRLevel.C2;
      default:
        throw ArgumentError('Unknown CEFR level: $value');
    }
  }
}
