import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Models/lesson_model_new.dart';
import 'package:speak_ez/Screens/Lessons/vocalbulary_screen.dart';

class LessonIntroScreen extends StatelessWidget {
  final Lesson lesson;
  const LessonIntroScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.shade300,
            ),
            child: Icon(Icons.close, color: Colors.black),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          SizedBox(
            width: Get.width * 0.5,
            height: Get.width * 0.5,
            child: Image.asset(AppAssets.cat),
          ),
          SizedBox(width: Get.width, height: 20),
          
          Text(
            "Welcome to the lesson",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10,),
          Text(
            lesson.lessonName,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: Get.width * 0.2, height: Get.width * 0.2),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              Get.to(VocalbularyScreen(lesson: lesson));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              fixedSize: Size(Get.width - 30, 50),
            ),
            child: Text(
              "Start",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}
