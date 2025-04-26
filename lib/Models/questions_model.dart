
class QuestionModel {
  final QuestionType type;

  // Common fields
  final String? question;
  final List<String>? options;
  final String? correctAnswer;

  // For flashcards
  final String? word;
  final String? imageUrl;
  final String? audioUrl;
  final String? translation;

  // For jumbled word
  final String? jumbledWord;

  // For jumbled sentence or sentence rearrangement
  final List<String>? jumbledSentence;

  // For error spotting
  final String? sentence;
  final String? correctSentence;

  // For word matching and idiom matching
  final List<Map<String, String>>? pairs;

  // For email writing
  final String? prompt;

  // For paraphrase
  final String? answer;

  QuestionModel({
    required this.type,
    this.question,
    this.options,
    this.correctAnswer,
    this.word,
    this.imageUrl,
    this.audioUrl,
    this.translation,
    this.jumbledWord,
    this.jumbledSentence,
    this.sentence,
    this.correctSentence,
    this.pairs,
    this.prompt,
    this.answer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      type: questionTypeFromString(json['type']),
      question: json['question'],
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      correctAnswer: json['correct_answer'],
      word: json['word'],
      imageUrl: json['image_url'],
      audioUrl: json['audio_url'],
      translation: json['translation'],
      jumbledWord: json['jumbled_word'],
      jumbledSentence: json['jumbled_sentence'] != null ? List<String>.from(json['jumbled_sentence']) : null,
      sentence: json['sentence'],
      correctSentence: json['correct_sentence'],
      pairs: json['pairs'] != null ? List<Map<String, String>>.from(
        (json['pairs'] as List).map((item) => Map<String, String>.from(item))
      ) : null,
      prompt: json['prompt'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': questionTypeToString(type),
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
      'word': word,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'translation': translation,
      'jumbled_word': jumbledWord,
      'jumbled_sentence': jumbledSentence,
      'sentence': sentence,
      'correct_sentence': correctSentence,
      'pairs': pairs,
      'prompt': prompt,
      'answer': answer,
    };
  }
}

String questionTypeToString(QuestionType type) {
  return type.toString().split('.').last;
}

QuestionType questionTypeFromString(String type) {
  return QuestionType.values.firstWhere((e) => e.toString().split('.').last == type);
}



enum QuestionType {
  flashcard,
  jumbled,
  fillInBlank,
  tapAudio,
  wordMatch,
  jumbledSentence, // (or sentenceRearrange)
  errorSpotting,
  paraphrase,
  idiomMatch,
  emailWriting,
  sentenceRearrange
}
