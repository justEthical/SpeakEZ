import 'package:speak_ez/Models/evaluation_result.dart';

final k = {
  "score": 0,
  "fluency": {"rating": 0, "feedback": ""},
  "grammar": {"rating": 0, "feedback": ""},
  "vocabulary": {"rating": 0, "feedback": ""},
  "pronunciation": {"rating": 0, "feedback": ""},
  "motivation": "",
  "suggestion": "",
  "correction": ["I'm good, how about you?", "I went to the market today."],
};

final sc = EvaluationResult(
  score: 80,
  fluency: FeedbackCategory(rating: 6, feedback: "feedback"),
  grammar: FeedbackCategory(rating: 6, feedback: "feedback"),
  vocabulary: FeedbackCategory(rating: 6, feedback: "feedback"),
  pronunciation: FeedbackCategory(rating: 6, feedback: "feedback"),
  motivation: "motivation",
  suggestion: "suggestion",
  correction: ["I'm good, how about you?", "I went to the market today."],
);
