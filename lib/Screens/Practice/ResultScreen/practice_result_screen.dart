import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Models/evaluation_result.dart';
import 'package:speak_ez/Utils/custom_loader.dart';

import 'Widgets/result_title.dart';
import 'Widgets/score_bar.dart';

class PracticeResultSreen extends StatelessWidget {
  final EvaluationResult result;
  PracticeResultSreen({super.key, required this.result});

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PracticeController>();
    final theme = Theme.of(context);
    c.updateLesssonProgress();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black54),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Result",
          style: GoogleFonts.nunito(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
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
            "Score: ${result.score}/100",
            style: GoogleFonts.nunito(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          ScoreBar(score: result.score),
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
    return Column(
      children: [
        ResultTile(
          onTap: () {},
          icon: AppAssets.fluency,
          heading: 'Fluency (${result.fluency.rating}/10)',
          content: result.fluency.feedback,
          padding: 10,
        ),
        ResultTile(
          onTap: () {},
          icon: AppAssets.grammar,
          heading: 'Grammar (${result.grammar.rating}/10)',
          content: result.grammar.feedback,
        ),
        ResultTile(
          onTap: () {},
          icon: AppAssets.vocabulary,
          heading: 'Vocabulary (${result.vocabulary.rating}/10)',
          content: result.vocabulary.feedback,
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
      ],
    );
  }

  Widget _buildDoneButton(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () => Get.back(),
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
