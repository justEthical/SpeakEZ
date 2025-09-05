import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Models/evaluation_result.dart';
import 'package:speak_ez/Screens/Practice/ResultScreen/detailed_result.dart';
import 'package:speak_ez/Screens/custom_review_screen.dart';
import 'package:speak_ez/Utils/custom_loader.dart';

import 'Widgets/result_title.dart';
import 'Widgets/score_bar.dart';

class PracticeResultSreen extends StatelessWidget {
  final FeedbackResult result;
  PracticeResultSreen({super.key, required this.result});

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PracticeController>();
    final theme = Theme.of(context);
    c.updatePracticeProgress();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,

        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: Colors.black54),
            onPressed: () async {
              CustomLoader.showLoader();
              await c.captureAndShare(globalKey);
              CustomLoader.hideLoader();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RepaintBoundary(
              key: globalKey,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: theme.scaffoldBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildScoreCard(context, c, theme),
                    const SizedBox(height: 24),
                    _buildMotivationCard(context, theme),
                    const SizedBox(height: 24),
                    _buildFeedbackSection(c),
                  ],
                ),
              ),
            ),
            _buildDoneButton(context, theme),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(
    BuildContext context,
    PracticeController c,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, theme.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            c.formatDateToLongString(DateTime.now()),
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Score: ${result.overallScore}/100",
            style: GoogleFonts.nunito(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          ScoreBar(score: result.overallScore),
        ],
      ),
    );
  }

  Widget _buildMotivationCard(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.1)),
      ),
      child: Text(
        result.motivation,
        textAlign: TextAlign.center,
        style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildFeedbackSection(PracticeController c) {
    final [scoreMap, feedbackList] = c.getAverageScoreAndFeedback();
    return Column(
      children: [
        ResultTile(
          onTap: () {},
          icon: AppAssets.fluency,
          heading: 'Fluency (${scoreMap['fluency']}/10)',
          content: result.fluency,
          padding: 10,
        ),
        ResultTile(
          onTap: () {},
          icon: AppAssets.grammar,
          heading: 'Grammar (${scoreMap['grammar']}/10)',
          content: result.grammar,
        ),
        ResultTile(
          onTap: () {},
          icon: AppAssets.vocabulary,
          heading: 'Vocabulary (${scoreMap['vocabulary']}/10)',
          content: result.vocabulary,
        ),
        ResultTile(
          onTap: () {},
          icon: AppAssets.prononciation,
          heading: 'Pronunciation (${scoreMap['pronunciation']}/10)',
          content: result.pronunciation,
        ),
        ResultTile(
          onTap: () {},
          icon: AppAssets.totalSpeakingTime,
          heading: 'Total Speaking Time',
          content: '${c.formatDuration(c.totalSpeakingTime)} Minutes',
        ),
        ResultTile(
          onTap: () {},
          icon: AppAssets.tip,
          heading: 'Suggestion',
          content: result.suggestion,
        ),
        InkWell(
          onTap: () {
            Get.to(() => const DetailedResult());
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Center(child: Text('Detailed Feedback')),
          ),
        ),
      ],
    );
  }

  Widget _buildDoneButton(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          Get.back();
          final completedSessions =
              globalController.prefs?.getInt(
                AppStrings.completedPracticeSessions,
              ) ??
              0;
          final isItTimeToShowCustomReview = completedSessions % 5;
          if ((isItTimeToShowCustomReview == 1) &&
              !globalController
                  .userProfile
                  .value
                  .isShownCustomReviewDialogOnce) {
            Get.to(() => const CustomReviewScreen());
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          "Done",
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
