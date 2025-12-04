import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    c.showRewardedInterstitialAd();
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,

        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
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
                    _buildFeedbackSection(c, context),
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
          colors: [Theme.of(context).colorScheme.primary, theme.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            c.formatDateToLongString(DateTime.now()),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: AppStrings.nunitoFont,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Score: ${c.getOverAllScore(result)}/100",
            style: TextStyle(
              fontSize: 36,
              fontFamily: AppStrings.nunitoFont,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          ScoreBar(score: c.getOverAllScore(result)),
        ],
      ),
    );
  }

  Widget _buildMotivationCard(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
      ),
      child: Text(
        result.motivation,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: AppStrings.nunitoFont,
          color: Theme.of(context).textTheme.bodyMedium?.color,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildFeedbackSection(PracticeController c, context) {
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
            height: 50,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: 1,
              ),
            ),

            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Detailed Feedback',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
              ],
            ),
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
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          "Done",
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontWeight: FontWeight.w800,
            fontFamily: AppStrings.nunitoFont,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
