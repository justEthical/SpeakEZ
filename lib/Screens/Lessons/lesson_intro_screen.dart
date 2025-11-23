import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Screens/Lessons/vocalbulary_screen.dart';
import 'package:speak_ez/Screens/Lessons/qna_screen.dart';
import 'package:speak_ez/Services/admob_service.dart';

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
      if (widget.lessonIndex != null) {
        c.isFromRetest = true;
      } else {
        c.isFromRetest = false;
      }
      // globalController.startWhisperIsolate();
      GoogleMobileAdsService.instance.loadRewarded(
        adUnitId: AppStrings.rewardedInterstitialAdUnitId,
      );
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
            child: Icon(
              Icons.close,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      ),
      body:
          c.lessonModel == null
              ? Center(child: CircularProgressIndicator())
              : Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    widget.isUnlockTest
                        ? SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(
                            AppAssets.key,
                            decoder: globalController.customDecoder,
                          ),
                        )
                        : SizedBox(
                          width: Get.width * 0.5,
                          height: Get.width * 0.5,
                          child: Image.asset(AppAssets.cat),
                        ),
                    SizedBox(width: Get.width, height: 20),
                    Text(
                      c.lessonModel!.lessonType == LessonType.unlockTest
                          ? "Level Unlock Test"
                          : "Welcome to the lesson",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: AppStrings.poppinsFont,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      c.lessonModel!.lessonName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: AppStrings.poppinsFont,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    c.isUnlockTest
                        ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "You have to score more than 80% to unlock the ${widget.englishLevel} level",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: AppStrings.poppinsFont,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                        : SizedBox(),
                    SizedBox(width: Get.width * 0.2, height: Get.width * 0.2),
                    Spacer(),
                    ElevatedButton(
                      onPressed: _navigateToQuestions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fixedSize: Size(Get.width - 30, 50),
                      ),
                      child: Text(
                        "Start",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppStrings.poppinsFont,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }
}
