// verify_lessons.dart
//
// Verifies that all JSON files in a folder can be parsed into the Lesson model
// you provided, and performs a few extra sanity checks.
//
// USAGE:
//   dart run verify_lessons.dart <path-to-folder>
// If no folder is passed, defaults to "assets/lessons".
//
// NOTE: Update the import below to match where your model lives.
import 'dart:convert';
import 'dart:io';

// TODO: change this to your real path, e.g.:
// import 'package:speakez/models/lesson.dart';

// ---- BEGIN: Inline model (only if you want this file to be standalone) ----
// If your project already has these classes, DELETE everything between these
// markers and import your model instead.

// Enums
enum LessonType { regular, unlockTest }
enum QuestionType {
  multipleChoice,
  fillInTheBlanks,
  trueFalse,
  sentenceRearranging,
  listening,
  speaking,
}

// Model classes (exactly as in your message)
class Lesson {
  final String id;
  final String lessonName;
  final String purpose;
  final String cefrLevel;
  final LessonIntro? lessonIntro; // optional for unlock tests
  final QuestionPools questionPools;
  final LessonType lessonType;

  Lesson({
    required this.id,
    required this.lessonName,
    required this.purpose,
    required this.cefrLevel,
    this.lessonIntro,
    required this.questionPools,
    this.lessonType = LessonType.regular,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
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

  factory Lesson.fromUnlockTest(Map<String, dynamic> json) => Lesson(
        id: json['id'],
        lessonName: json['lesson_name'],
        purpose: json['purpose'],
        cefrLevel: json['cefrLevel'],
        lessonIntro: null,
        questionPools: QuestionPools.fromJson(json['question_pools']),
        lessonType: LessonType.unlockTest,
      );
}

class LessonIntro {
  final List<VocabularyItem> vocabulary;
  final List<GrammarTip> grammarTips;

  LessonIntro({required this.vocabulary, required this.grammarTips});

  factory LessonIntro.fromJson(Map<String, dynamic> json) => LessonIntro(
        vocabulary: (json['vocabulary'] as List)
            .map((e) => VocabularyItem.fromJson(e))
            .toList(),
        grammarTips: (json['grammar_tips'] as List)
            .map((e) => GrammarTip.fromJson(e))
            .toList(),
      );
}

class VocabularyItem {
  final String word;
  final Map<String, String>? wordTranslation;
  final String meaning;
  final Map<String, String>? meaningTranslation;
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
        wordTranslation: json['word_translation'] != null
            ? Map<String, String>.from(json['word_translation'])
            : null,
        meaning: json['meaning'],
        meaningTranslation: json['meaning_translation'] != null
            ? Map<String, String>.from(json['meaning_translation'])
            : null,
        examples: (json['examples'] as List)
            .map((e) => ExampleSentence.fromJson(e))
            .toList(),
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

  ExampleSentence({required this.sentence, this.translation});

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
  final List<Question>? grammar; // optional for unlock tests
  final List<Question> sentence;
  final List<Question> listening;
  final List<Question> speaking;

  QuestionPools({
    required this.vocabulary,
    this.grammar,
    required this.sentence,
    required this.listening,
    required this.speaking,
  });

  factory QuestionPools.fromJson(Map<String, dynamic> json) => QuestionPools(
        vocabulary: (json['vocabulary'] as List)
            .map((e) => Question.fromJson(e))
            .toList(),
        grammar: json['grammar'] != null
            ? (json['grammar'] as List)
                .map((e) => Question.fromJson(e))
                .toList()
            : null,
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
  final Map<String, String>? questionTranslation;
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
    Map<String, String>? translation;
    if (json['question_translation'] != null) {
      final trans = json['question_translation'];
      if (trans is Map) {
        translation = Map<String, String>.from(trans);
      }
    }
    return Question(
      id: json['id'],
      type: QuestionType.values
          .firstWhere((e) => e.name == json['type'], orElse: () {
        throw FormatException(
            "Unknown QuestionType '${json['type']}'. Expected one of: "
            "${QuestionType.values.map((e) => e.name).join(', ')}");
      }),
      question: json['question'],
      audioText: json['audio_text'],
      questionTranslation: translation,
      options: json['options'] as List<dynamic>?,
      answer: json['answer'],
    );
  }
}
// ---- END: Inline model ----

class FileResult {
  final String path;
  final bool ok;
  final List<String> warnings;
  final List<String> errors;

  FileResult(this.path, this.ok, this.warnings, this.errors);
}

void main(List<String> args) async {
  final folder = args.isEmpty ? 'assets/lessons' : args.first;
  final dir = Directory(folder);

  if (!await dir.exists()) {
    stderr.writeln('Folder not found: $folder');
    exitCode = 2;
    return;
  }

  final jsonFiles = dir
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .where((f) => f.path.toLowerCase().endsWith('.json'))
      .toList();

  if (jsonFiles.isEmpty) {
    stdout.writeln('No .json files found under: $folder');
    return;
  }

  stdout.writeln('Scanning ${jsonFiles.length} JSON file(s) in "$folder"...\n');

  final results = <FileResult>[];
  for (final file in jsonFiles) {
    results.add(await _validateFile(file));
  }

  // Report
  int okCount = 0, warnCount = 0, errCount = 0;
  for (final r in results) {
    final status = r.ok
        ? (r.warnings.isEmpty ? 'OK' : 'OK (warnings)')
        : 'ERROR';
    if (r.ok) {
      okCount++;
      if (r.warnings.isNotEmpty) warnCount++;
    } else {
      errCount++;
    }

    stdout.writeln('• ${r.path}  ->  $status');
    for (final w in r.warnings) {
      stdout.writeln('   ⚠️  $w');
    }
    for (final e in r.errors) {
      stdout.writeln('   ❌  $e');
    }
  }

  stdout.writeln('\nSummary:');
  stdout.writeln('  ✅ Parsed OK:           $okCount/${results.length}');
  stdout.writeln('  ⚠️  With warnings:       $warnCount');
  stdout.writeln('  ❌ Failed to parse:      $errCount');

  if (errCount > 0) {
    exitCode = 1; // non-zero exit for CI
  }
}

Future<FileResult> _validateFile(File file) async {
  final warnings = <String>[];
  final errors = <String>[];

  Map<String, dynamic> root;
  try {
    final text = await file.readAsString();
    final decoded = jsonDecode(text);
    if (decoded is! Map<String, dynamic>) {
      errors.add('Top-level JSON is not an object.');
      return FileResult(file.path, false, warnings, errors);
    }
    root = decoded;
  } catch (e) {
    errors.add('JSON decode error: $e');
    return FileResult(file.path, false, warnings, errors);
  }

  // Try parsing into Lesson model
  Lesson lesson;
  try {
    lesson = Lesson.fromJson(root);
  } catch (e, st) {
    errors.add('Lesson.fromJson failed: $e');
    // Optional: add a short stack (first line) to help locate the cause
    final firstLine = st.toString().split('\n').first;
    warnings.add('Stack hint: $firstLine');
    return FileResult(file.path, false, warnings, errors);
  }

  // Basic required-field checks
  void _req(String name, dynamic value) {
    if (value == null ||
        (value is String && value.trim().isEmpty)) {
      warnings.add('Required field "$name" is empty/null.');
    }
  }

  _req('id', lesson.id);
  _req('lesson_name', lesson.lessonName);
  _req('purpose', lesson.purpose);
  _req('cefrLevel', lesson.cefrLevel);

  // Unlock test vs regular expectations
  final isUnlock = lesson.lessonType == LessonType.unlockTest;
  if (!isUnlock && lesson.lessonIntro == null) {
    warnings.add(
        'Regular lesson has no "lesson_intro". (Allowed by model but unexpected.)');
  }
  if (isUnlock && lesson.lessonIntro != null) {
    warnings.add(
        'Unlock test includes "lesson_intro". (Model ignores it; consider removing.)');
  }

  // Pools presence/emptiness checks
  _checkPool('vocabulary', lesson.questionPools.vocabulary, warnings);
  _checkPool('sentence', lesson.questionPools.sentence, warnings);
  _checkPool('listening', lesson.questionPools.listening, warnings);
  _checkPool('speaking', lesson.questionPools.speaking, warnings);
  // Grammar may be null (esp. unlock tests)
  if (lesson.questionPools.grammar == null) {
    if (!isUnlock) {
      warnings.add('Grammar pool is null in a regular lesson.');
    }
  } else {
    _checkPool('grammar', lesson.questionPools.grammar!, warnings);
  }

  // Validate each question and enum type mapping
  final allQs = lesson.questionPools.allQuestions;
  final seenIds = <String>{};
  for (final q in allQs) {
    // Duplicate ID check
    if (!seenIds.add(q.id)) {
      warnings.add('Duplicate question id "${q.id}".');
    }
    // Type-specific expectations
    switch (q.type) {
      case QuestionType.multipleChoice:
        if (q.options == null || q.options!.isEmpty) {
          warnings.add(
              'multipleChoice question "${q.id}" has empty/missing options.');
        }
        break;
      case QuestionType.trueFalse:
        // Often answer should be a bool; we only warn if not bool.
        if (q.answer is! bool) {
          warnings.add(
              'trueFalse question "${q.id}" answer should be a boolean.');
        }
        break;
      case QuestionType.fillInTheBlanks:
      case QuestionType.sentenceRearranging:
      case QuestionType.listening:
      case QuestionType.speaking:
        // No strict checks beyond presence of question/answer
        break;
    }

    // Minimal presence check
    if (q.question.trim().isEmpty) {
      warnings.add('Question "${q.id}" has empty "question" text.');
    }
    if (q.answer == null ||
        (q.answer is String && (q.answer as String).trim().isEmpty)) {
      warnings.add('Question "${q.id}" has empty/null "answer".');
    }
  }

  // Extra lessonIntro sanity checks (if present)
  final intro = lesson.lessonIntro;
  if (intro != null) {
    if (intro.vocabulary.isEmpty) {
      warnings.add('lesson_intro.vocabulary is empty.');
    }
    if (intro.grammarTips.isEmpty) {
      warnings.add('lesson_intro.grammar_tips is empty.');
    }
    // Quick scan for missing translations structure
    for (final v in intro.vocabulary) {
      if (v.examples.isEmpty) {
        warnings.add('Vocabulary "${v.word}" has no examples.');
      }
    }
  }

  final ok = errors.isEmpty;
  return FileResult(file.path, ok, warnings, errors);
}

void _checkPool(String name, List<Question> pool, List<String> warnings) {
  if (pool.isEmpty) {
    warnings.add('Question pool "$name" is empty.');
  }
}
