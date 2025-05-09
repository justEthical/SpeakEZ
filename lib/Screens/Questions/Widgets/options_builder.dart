import 'package:flutter/material.dart';
import 'package:speak_ez/Models/questions_model.dart';
import 'package:speak_ez/Screens/Questions/Widgets/mcq_options_builder.dart';
import 'package:speak_ez/Screens/Questions/Widgets/sentence_rearrange.dart';

class OptionsBuilderByType extends StatelessWidget {
  final List<dynamic> options;
  final QuestionType type;
  const OptionsBuilderByType({
    super.key,
    required this.options,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case QuestionType.sentenceRearranging:
        return SentenceRearrange(options: options, questionType: type);

      default:
        return MCQOptionsBuilder(options: options, questionType: type);
    }
  }
}
