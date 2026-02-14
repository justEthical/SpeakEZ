enum LessonType {
  regular,
  unlockTest,
}

class Lesson {
  final String id;
  final String lessonName;
  final String purpose;
  final String cefrLevel;
  final LessonIntro? lessonIntro; // Made optional for unlock tests
  final QuestionPools questionPools;
  final LessonType lessonType;

  Lesson({
    required this.id,
    required this.lessonName,
    required this.purpose,
    required this.cefrLevel,
    this.lessonIntro, // Optional
    required this.questionPools,
    this.lessonType = LessonType.regular,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    // Detect if this is an unlock test based on purpose
    final isUnlockTest = json['purpose'] == 'LevelUnlockTest';

    return Lesson(
      id: json['id'],
      lessonName: json['lesson_name'] ?? json['lessonName'],
      purpose: json['purpose'],
      cefrLevel: json['cefrLevel'],
      lessonIntro: json['lesson_intro'] != null
          ? LessonIntro.fromJson(json['lesson_intro'])
          : null,
      questionPools: QuestionPools.fromJson(json['question_pools']),
      lessonType: isUnlockTest ? LessonType.unlockTest : LessonType.regular,
    );
  }

  // Factory constructor for UnlockTest compatibility
  factory Lesson.fromUnlockTest(Map<String, dynamic> json) => Lesson(
    id: json['id'],
    lessonName: json['lesson_name'],
    purpose: json['purpose'],
    cefrLevel: json['cefrLevel'],
    lessonIntro: null, // No intro for unlock tests
    questionPools: QuestionPools.fromJson(json['question_pools']),
    lessonType: LessonType.unlockTest,
  );
}

class LessonIntro {
  final List<VocabularyItem> vocabulary;
  final List<GrammarTip> grammarTips;

  LessonIntro({required this.vocabulary, required this.grammarTips});

  factory LessonIntro.fromJson(Map<String, dynamic> json) => LessonIntro(
    vocabulary:
        (json['vocabulary'] as List)
            .map((e) => VocabularyItem.fromJson(e))
            .toList(),
    grammarTips:
        (json['grammar_tips'] as List)
            .map((e) => GrammarTip.fromJson(e))
            .toList(),
  );
}

class VocabularyItem {
  final String word;
  final String? wordTranslation;
  final String meaning;
  final String? meaningTranslation;
  final List<ExampleSentence> examples;

  VocabularyItem({
    required this.word,
    this.wordTranslation,
    required this.meaning,
    this.meaningTranslation,
    required this.examples,
  });

  factory VocabularyItem.fromJson(Map<String, dynamic> json) => VocabularyItem(
    word: json['word'],
    wordTranslation: json['word_translation'],
    meaning: json['meaning'],
    meaningTranslation: json['meaning_translation'],
    examples:
        (json['examples'] as List)
            .map((e) => ExampleSentence.fromJson(e))
            .toList(),
  );
}

class GrammarTip {
  final String title;
  final String explanation;
  final String? explanationTranslation;

  GrammarTip({
    required this.title,
    required this.explanation,
    this.explanationTranslation,
  });

  factory GrammarTip.fromJson(Map<String, dynamic> json) => GrammarTip(
    title: json['title'],
    explanation: json['explanation'],
    explanationTranslation: json['explanation_translation'],
  );
}

class ExampleSentence {
  final String sentence;
  final String? translation;

  ExampleSentence({required this.sentence, this.translation});

  factory ExampleSentence.fromJson(Map<String, dynamic> json) =>
      ExampleSentence(
        sentence: json['sentence'],
        translation: json['translation'],
      );
}

class QuestionPools {
  final List<Question> vocabulary;
  final List<Question>? grammar; // Optional for unlock tests
  final List<Question> sentence;
  final List<Question> listening;
  final List<Question> speaking;

  QuestionPools({
    required this.vocabulary,
    this.grammar, // Optional
    required this.sentence,
    required this.listening,
    required this.speaking,
  });

  factory QuestionPools.fromJson(Map<String, dynamic> json) => QuestionPools(
    vocabulary:
        (json['vocabulary'] as List).map((e) => Question.fromJson(e)).toList(),
    grammar: json['grammar'] != null
        ? (json['grammar'] as List).map((e) => Question.fromJson(e)).toList()
        : null,
    sentence:
        (json['sentence'] as List).map((e) => Question.fromJson(e)).toList(),
    listening:
        (json['listening'] as List).map((e) => Question.fromJson(e)).toList(),
    speaking:
        (json['speaking'] as List).map((e) => Question.fromJson(e)).toList(),
  );

  // Helper to get all questions for unlock tests
  List<Question> get allQuestions {
    final all = <Question>[];
    all.addAll(vocabulary);
    if (grammar != null) all.addAll(grammar!);
    all.addAll(sentence);
    all.addAll(listening);
    all.addAll(speaking);
    return all;
  }
}

class Question {
  final String id;
  final QuestionType type;
  final String question;
  final String? audioText;
  final String? questionTranslation;
  final List<dynamic>? options;
  final dynamic answer;

  Question({
    required this.id,
    required this.type,
    required this.question,
    this.audioText,
    this.questionTranslation,
    this.options,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      type: QuestionType.values.firstWhere((e) => e.name == json['type']),
      question: json['question'],
      audioText: json['audio_text'],
      questionTranslation: json['question_translation'],
      options: json['options'] as List<dynamic>?,
      answer: json['answer'],
    );
  }
}

enum QuestionType {
  multipleChoice,
  fillInTheBlanks,
  trueFalse,
  sentenceRearranging,
  listening,
  speaking,
}
