class Lesson {
  final String id;
  final String lessonName;
  final String purpose;
  final String cefrLevel;
  final List<QuestionGroup> questions;

  Lesson({
    required this.id,
    required this.lessonName,
    required this.purpose,
    required this.cefrLevel,
    required this.questions,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      lessonName: json['lesson_name'],
      purpose: json['purpose'],
      cefrLevel: json['cefrLevel'],
      questions: (json['questions'] as List)
          .map((q) => QuestionGroup.fromJson(q))
          .toList(),
    );
  }
}

class QuestionGroup {
  final List<Question> questionByDifficulty;

  QuestionGroup({required this.questionByDifficulty});

  factory QuestionGroup.fromJson(Map<String, dynamic> json) {
    return QuestionGroup(
      questionByDifficulty: (json['questionByDifficulty'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}

class Question {
  final QuestionType type;
  final String question;
  final List<dynamic> options;
  final dynamic answer;

  Question({
    required this.type,
    required this.question,
    required this.options,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: questionTypeFromString(json['type']),
      question: json['question'],
      options: List<dynamic>.from(json['options']),
      answer: json['answer'],
    );
  }
}


enum QuestionType {
  multipleChoice,
  fillInTheBlanks,
  speaking,
  trueFalse,
  sentenceRearranging,
  listening,
  synonymsMatching,
  shortAnswer
}

QuestionType questionTypeFromString(String type) {
  switch (type) {
    case 'multipleChoice':
      return QuestionType.multipleChoice;
    case 'fillInTheBlanks':
      return QuestionType.fillInTheBlanks;
    case 'speaking':
      return QuestionType.speaking;
    case 'trueFalse':
      return QuestionType.trueFalse;
    case 'sentenceRearranging':
      return QuestionType.sentenceRearranging;
    case 'listening':
      return QuestionType.listening;
    case 'synonymsMatching':
      return QuestionType.synonymsMatching;
    default:
      throw Exception('Unknown QuestionType: $type');
  }
}

enum CEFRLevel {
  A1,
  A2,
  B1,
  B2,
  C1,
  C2
}

CEFRLevel cefrLevelFromString(String level) {
  switch (level) {
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
      throw Exception('Unknown CEFR level: $level');
  }
}

