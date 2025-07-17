import 'package:flutter/material.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/mcq_options.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/sentence_rearrange_options.dart';

class OptionBuilder extends StatelessWidget {
  final Question question;
  const OptionBuilder({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case QuestionType.sentenceRearranging:
        return SentenceRearrangeOptions(question: question) ;
      case QuestionType.speaking:
        return const Text("Option 7");
      default:
        // default option type will be multiple choice
        return McqOptions(question: question);
    }
  }
}
