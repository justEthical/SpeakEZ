import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

class McqOptions extends StatefulWidget {
  final Question question;
  const McqOptions({super.key, required, required this.question});

  @override
  State<McqOptions> createState() => _McqOptionsState();
}

class _McqOptionsState extends State<McqOptions> {
  final c = Get.find<QuestionOptionsController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      c.currentSelectedOptionIndex.value = 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(widget.question.options!.length, (i) {
          return Obx(() => InkWell(
                      onTap: () {
                        ttsHelper.speak(widget.question.options![i]);
                        c.currentSelectedOptionIndex.value = i;
                        c.shouldEnableContinueButton(widget.question.type);
                        
                      },
                      child: Container(
                        width: Get.width - 30,
                        height: 50,
                        margin: EdgeInsets.only(bottom: 7),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.4),
                          color: c.currentSelectedOptionIndex.value == i ? Colors.deepPurple : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color:  Colors.grey.shade100,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            widget.question.options![i],
                            textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: c.currentSelectedOptionIndex.value == i ? Colors.white : Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),)
          );
        }),
      ],
    );
  }
}
