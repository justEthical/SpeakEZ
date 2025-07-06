import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

import '../../Models/lesson_model_new.dart' show Lesson;

class VocalbularyScreen extends StatelessWidget {
  final Lesson lesson;
  const VocalbularyScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          "Vocalbulary",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  lesson.lessonIntro.vocabulary.length,
                  (e) => GestureDetector(
                    onTap: () {},
                    child: Container(
                      width:
                          (Get.width / lesson.lessonIntro.vocabulary.length) -
                          10,
                      height: 4,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.4),
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  lesson.lessonIntro.vocabulary[0].word,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    final tts = TextToSpeechService();
                    tts.speak(lesson.lessonIntro.vocabulary[0].word);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), color: Colors.black),
                    child: SvgPicture.asset(AppAssets.speak, color: Colors.white  ,)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
