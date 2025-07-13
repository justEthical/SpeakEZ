import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';

class McqOptions extends StatelessWidget {
  final Question question;
  const McqOptions({super.key, required, required this.question});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    c.currentSelectedOptionIndex.value = 100;
    c.shouldEnableContinueButton(question.type);
    return Column(
      children: [
        ...List.generate(question.options!.length, (i) {
          return InkWell(
            onTap: () {
               c.currentSelectedOptionIndex.value = i;
               c.shouldEnableContinueButton(question.type);
            },
            child: Container(
              width: Get.width - 30,
              height: 50,
              margin: EdgeInsets.only(bottom: 7),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.4),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  question.options![i],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
