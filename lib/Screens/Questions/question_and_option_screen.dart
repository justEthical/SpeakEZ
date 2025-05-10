import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Models/questions_model.dart';
import 'package:speak_ez/Screens/Questions/Widgets/continue_button.dart';
import 'Widgets/options_builder.dart';
import 'Widgets/progress_bar.dart';

class QuestionAndOptionScreen extends StatelessWidget {
  const QuestionAndOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          c.currentLesson.value.lessonName,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          GestureDetector(
            onTap: () => c.showExitBottomSheet(context),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 20, color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            ProgressBar(),
            const SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: c.questionPageController,
                itemBuilder: (ctx, i) {
                  Question question =
                      c.currentLesson.value.questions[i].questionByDifficulty[c
                          .questionDifficultyLevel
                          .value];
                  c.shouldEnableContinueButton(question.type);
                  return Column(
                    children: [
                      Text(
                        question.question,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      OptionsBuilderByType(
                        options: question.options,
                        type: question.type,
                      ),
                      SizedBox(height: 12),
                      ContinueButton(question: question),
                    ],
                  );
                },
                itemCount: c.currentLesson.value.questions.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
