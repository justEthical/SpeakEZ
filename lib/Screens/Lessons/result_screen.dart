import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Screens/custom_review_screen.dart';
import 'package:speak_ez/Screens/tab_bar_screen.dart';
import 'package:speak_ez/Services/admob_service.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    final accuracy =
        (c.correctAnswer.value / c.currentQuestionList.length) * 100;
    globalController.userProfile.value.gems += accuracy.toInt();
    if (!c.isFromRetest || !c.isUnlockTest) {
      c.updateLesssonProgress();
    }
    if (c.isUnlockTest) {
      c.updateEnglishLevel();
    }
    final timeTookForQnaInSeconds =
        DateTime.now().difference(c.qnaStartTime).inSeconds;
    final timeTookForQna = c.formatSecondsToMinutes(timeTookForQnaInSeconds);
    if (globalController.isWhisperInitialized.value) {
      globalController.whisperSendPort?.send('stop');
      globalController.isWhisperInitialized.value = false;
    }
    return Scaffold(
      body: Stack(
        children: [
          // Confetti background animation
          (accuracy >= 80 || !c.isUnlockTest)
              ? Lottie.asset(
                AppAssets.confetti,
                width: Get.width,
                height: Get.height,
                decoder: globalController.customDecoder,
                repeat: false,
                fit: BoxFit.cover,
              )
              : SizedBox(),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  _buildHeaderText(context),
                  const SizedBox(height: 16),
                  _buildResultText(c, accuracy, context),
                  const Spacer(flex: 1),
                  _buildCenterAnimation(accuracy), // Center animation(),
                  const Spacer(flex: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildResultAnalyticCard(
                        context,
                        "${accuracy.toStringAsFixed(0)}%",
                        "Accuracy",
                        Colors.green,
                      ),
                      _buildResultAnalyticCard(
                        context,
                        timeTookForQna,
                        "Time Taken",
                        Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildDoneButton(context),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText(context) {
    return Text(
      "Lesson Completed",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        fontFamily: AppStrings.nunitoFont,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }

  Widget _buildResultText(
    QuestionOptionsController c,
    double accuracy,
    context,
  ) {
    return Text(
      c.getResultScreenText(accuracy),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppStrings.nunitoFont,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCenterAnimation(accuracy) {
    final c = Get.find<QuestionOptionsController>();
    if (c.isUnlockTest) {
      if (accuracy >= 80) {
        return SizedBox(
          width: 180,
          height: 180,
          child: Lottie.asset(
            AppAssets.unlock,
            decoder: globalController.customDecoder,
            repeat: true,
          ),
        );
      } else {
        return SizedBox(
          width: 180,
          height: 180,
          child: Lottie.asset(
            AppAssets.locked,
            decoder: globalController.customDecoder,
            repeat: false,
          ),
        );
      }
    }
    return SizedBox(
      width: 180,
      height: 180,
      child: Lottie.asset(
        AppAssets.resultSuccess,
        decoder: globalController.customDecoder,
        repeat: true,
      ),
    );
  }

  Widget _buildResultAnalyticCard(
    BuildContext context,
    String analytics,
    String analyticsTitle,
    Color color,
  ) {
    return SizedBox(
      width: Get.width * 0.5 - 30,
      child: Card(
        elevation: 8,
        shadowColor: color.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: color.withOpacity(0.5), width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    analytics,
                    style: TextStyle(
                      color: color,
                      fontSize: 25,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: color),
                  child: Center(
                    child: Text(
                      analyticsTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoneButton(context) {
    return ElevatedButton(
      onPressed: () {
        GoogleMobileAdsService.instance.showRewardedInterstitial(
          onReward: (reward) {
            Get.find<QuestionOptionsController>().isFromRetest = false;
            Get.offAll(() => const TabBarScreen());
            final isItTimeToShowCustomReview =
                globalController.userProfile.value.currentEnglishLevelProgress %
                5;
            if ((isItTimeToShowCustomReview == 2) &&
                !globalController
                    .userProfile
                    .value
                    .isShownCustomReviewDialogOnce) {
              Get.to(() => const CustomReviewScreen());
            }
            Get.delete<QuestionOptionsController>(force: true);
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        fixedSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: TextStyle(
          fontSize: 18,
          fontFamily: AppStrings.nunitoFont,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(
        "Done",
        style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
      ),
    );
  }
}
