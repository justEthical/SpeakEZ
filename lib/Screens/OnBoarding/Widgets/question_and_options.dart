import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/onboardin_questions_model.dart';

/// A widget that displays a question with multiple options.
/// When an option is tapped, it changes to purple with white text.
class QuestionAndOptions extends StatelessWidget {
  const QuestionAndOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // width: Get.width - 16,
        // height: 400,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: PageView.builder(
          itemCount: onboardingQuestions.length,
          scrollDirection: Axis.horizontal,
          controller: globalController.onboardingQuestionsController,
          itemBuilder: (ctx, i) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${i + 1} of ${onboardingQuestions.length}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                Text(
                  onboardingQuestions[i].question,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                ...List.generate(
                  onboardingQuestions[i].options.length,
                  (j) => _buildOptionButton(onboardingQuestions[i].options[j]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptionButton(String label) {
    return GestureDetector(
      onTap: () {
        if (globalController.onboardingQuestionsController.page! < 3) {
          globalController.onboardingQuestionsController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
          globalController.currentOnboardingQuestionIndex.value++;
        }
      },
      child: Container(
        width: Get.width,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
