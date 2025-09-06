import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Screens/custom_review_screen.dart';
import 'package:speak_ez/Screens/tab_bar_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    final accuracy =
        (c.correctAnswer.value / c.currentQuestionList.length) * 100;
    c.updateLesssonProgress();
    final timeTookForQnaInSeconds =
        DateTime.now().difference(c.qnaStartTime).inSeconds;
    final timeTookForQna = c.formatSecondsToMinutes(timeTookForQnaInSeconds);
    if (globalController.isWhisperInitialized.value) {
      globalController.whisperSendPort.send('stop');
      globalController.isWhisperInitialized.value = false;
    }
    // c.ttsHelper.stop();
    return Scaffold(
      body: Stack(
        children: [
          // Confetti background animation
          Lottie.asset(
            AppAssets.confetti,
            width: Get.width,
            height: Get.height,
            decoder: globalController.customDecoder,
            repeat: false,
            fit: BoxFit.cover,
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  _buildHeaderText(),
                  const SizedBox(height: 16),
                  _buildResultText(c, accuracy),
                  const Spacer(flex: 1),
                  _buildSuccessAnimation(),
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
                  _buildDoneButton(),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText() {
    return Text(
      "Lesson Completed",
      textAlign: TextAlign.center,
      style: GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildResultText(QuestionOptionsController c, double accuracy) {
    return Text(
      c.getResultScreenText(accuracy),
      textAlign: TextAlign.center,
      style: GoogleFonts.nunito(
        color: Colors.black54,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSuccessAnimation() {
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
                    style: GoogleFonts.nunito(
                      color: color,
                      fontSize: 25,
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
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 20,
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

  Widget _buildDoneButton() {
    return ElevatedButton(
      onPressed: () {
        Get.offAll(() => const TabBarScreen());
        final isItTimeToShowCustomReview =
            globalController.userProfile.value.currentEnglishLevelProgress % 5;
        if ((isItTimeToShowCustomReview == 2) &&
            !globalController.userProfile.value.isShownCustomReviewDialogOnce) {
          Get.to(() => const CustomReviewScreen());
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        fixedSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: const Text("Done", style: TextStyle(color: Colors.white)),
    );
  }
}
