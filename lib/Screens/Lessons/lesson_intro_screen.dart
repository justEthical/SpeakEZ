import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Screens/Lessons/vocalbulary_screen.dart';
import 'package:speak_ez/Screens/Lessons/qna_screen.dart';

class LessonIntroScreen extends StatefulWidget {
  final int? lessonIndex;
  final String? englishLevel;
  final bool isUnlockTest;
  const LessonIntroScreen({
    super.key, 
    this.lessonIndex, 
    this.englishLevel,
    this.isUnlockTest = false,
  });

  @override
  State<LessonIntroScreen> createState() => _LessonIntroScreenState();
}

class _LessonIntroScreenState extends State<LessonIntroScreen> {
  final c = Get.put(QuestionOptionsController(), permanent: true);
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.isUnlockTest) {
        // Load unlock test from UnlockLevel folder
        c.lessonModel = await c.setUnlockTest(widget.englishLevel ?? 'A1');
      } else {
        c.lessonModel = await c.setCurrentLesson(
          lessonIndex: widget.lessonIndex,
          englishLevel: widget.englishLevel,
        );
      }
      c.isUnlockTest = widget.isUnlockTest;
      c.englishLevel = widget.englishLevel;
      setState(() {});
      c.currentLessonModel = c.lessonModel!;
      c.currentQuestionIndex.value = 0;
      if(widget.lessonIndex != null){
        c.isFromRetest = true;
      }
      globalController.startWhisperIsolate();
      
      
    });
  }
  
  void _navigateToQuestions() {
    if (c.lessonModel!.lessonType == LessonType.unlockTest) {
      // unlock lesson test flow
      Get.off(QnaScreen(lesson: c.lessonModel!));
    } else {
      // Regular lesson flow
      Get.off(VocalbularyScreen(lesson: c.lessonModel!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Get.back();
            Get.delete<QuestionOptionsController>(force: true);
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
      body:
          c.lessonModel == null
              ? Center(child: CircularProgressIndicator())
              : Column(
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
                    c.lessonModel!.lessonType == LessonType.unlockTest 
                        ? "Level Unlock Test"
                        : "Welcome to the lesson",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    c.lessonModel!.lessonName,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.2, height: Get.width * 0.2),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _navigateToQuestions,
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
                  SizedBox(height: 20),
                ],
              ),
    );
  }
}
