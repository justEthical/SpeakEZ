class Lesson {
  final String id;
  final String lessonName;
  final String purpose;
  final String cefrLevel;
  final LessonIntro lessonIntro;
  final QuestionPools questionPools;

  Lesson({
    required this.id,
    required this.lessonName,
    required this.purpose,
    required this.cefrLevel,
    required this.lessonIntro,
    required this.questionPools,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'],
        lessonName: json['lesson_name'],
        purpose: json['purpose'],
        cefrLevel: json['cefrLevel'],
        lessonIntro: LessonIntro.fromJson(json['lesson_intro']),
        questionPools: QuestionPools.fromJson(json['question_pools']),
      );
}

class LessonIntro {
  final List<VocabularyItem> vocabulary;
  final List<GrammarTip> grammarTips;
  final List<ExampleSentence> exampleSentences;

  LessonIntro({
    required this.vocabulary,
    required this.grammarTips,
    required this.exampleSentences,
  });

  factory LessonIntro.fromJson(Map<String, dynamic> json) => LessonIntro(
        vocabulary: (json['vocabulary'] as List)
            .expand((v) => v is List ? v : [v])
            .map((e) => VocabularyItem.fromJson(e))
            .toList(),
        grammarTips: (json['grammar_tips'] as List)
            .map((e) => GrammarTip.fromJson(e))
            .toList(),
        exampleSentences: (json['example_sentences'] as List)
            .map((e) => ExampleSentence.fromJson(e))
            .toList(),
      );
}

class VocabularyItem {
  final String word;
  final Map<String, String>? wordTranslation;
  final String meaning;
  final Map<String, String>? meaningTranslation;

  VocabularyItem({
    required this.word,
    this.wordTranslation,
    required this.meaning,
    this.meaningTranslation,
  });

  factory VocabularyItem.fromJson(Map<String, dynamic> json) => VocabularyItem(
        word: json['word'],
        wordTranslation: json['word_translation'] != null
            ? Map<String, String>.from(json['word_translation'])
            : null,
        meaning: json['meaning'],
        meaningTranslation: json['meaning_translation'] != null
            ? Map<String, String>.from(json['meaning_translation'])
            : null,
      );
}

class GrammarTip {
  final String title;
  final String explanation;
  final Map<String, String>? explanationTranslation;

  GrammarTip({
    required this.title,
    required this.explanation,
    this.explanationTranslation,
  });

  factory GrammarTip.fromJson(Map<String, dynamic> json) => GrammarTip(
        title: json['title'],
        explanation: json['explanation'],
        explanationTranslation: json['explanation_translation'] != null
            ? Map<String, String>.from(json['explanation_translation'])
            : null,
      );
}

class ExampleSentence {
  final String sentence;
  final Map<String, String>? translation;

  ExampleSentence({
    required this.sentence,
    this.translation,
  });

  factory ExampleSentence.fromJson(Map<String, dynamic> json) =>
      ExampleSentence(
        sentence: json['sentence'],
        translation: json['translation'] != null
            ? Map<String, String>.from(json['translation'])
            : null,
      );
}

class QuestionPools {
  final List<Question> vocabulary;
  final List<Question> sentence;
  final List<Question> listening;
  final List<Question> speaking;

  QuestionPools({
    required this.vocabulary,
    required this.sentence,
    required this.listening,
    required this.speaking,
  });

  factory QuestionPools.fromJson(Map<String, dynamic> json) => QuestionPools(
        vocabulary: (json['vocabulary'] as List)
            .map((e) => Question.fromJson(e))
            .toList(),
        sentence: (json['sentence'] as List)
            .map((e) => Question.fromJson(e))
            .toList(),
        listening: (json['listening'] as List)
            .map((e) => Question.fromJson(e))
            .toList(),
        speaking: (json['speaking'] as List)
            .map((e) => Question.fromJson(e))
            .toList(),
      );
}

class Question {
  final String id;
  final String type;
  final String question;
  final Map<String, String>? questionTranslation;
  final List<dynamic>? options;
  final dynamic answer;

  Question({
    required this.id,
    required this.type,
    required this.question,
    this.questionTranslation,
    this.options,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'],
        type: json['type'],
        question: json['question'],
        questionTranslation: json['question_translation'] != null
            ? Map<String, String>.from(json['question_translation'])
            : null,
        options: json['options'] as List<dynamic>?,
        answer: json['answer'],
      );
}
