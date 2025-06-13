import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Models/evaluation_result.dart';
import 'package:speak_ez/Screens/Practice/ResultScreen/Widgets/practice_app_bar.dart';

import 'Widgets/result_title.dart';
import 'Widgets/score_bar.dart';

class PracticeResultSreen extends StatelessWidget {
  final EvaluationResult result;
  const PracticeResultSreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PracticeController>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PracticeAppBar(),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Monday, 15th March 2023",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Score: ${result.score}/100",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      SizedBox(height: 10),
                      ScoreBar(score: result.score),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                ResultTile(
                  onTap: () async {
                    // Get.dialog(const DeleteAccountDialog());
                  },
                  icon: AppAssets.fluency,
                  heading: 'Fluency',
                  content: result.fluency.feedback,
                  padding: 10,
                ),
                ResultTile(
                  onTap: () async {
                    // Get.dialog(const DeleteAccountDialog());
                  },
                  icon: AppAssets.grammar,
                  heading: 'Grammer',
                  content: result.grammar.feedback,
                ),
                ResultTile(
                  onTap: () async {
                    // Get.dialog(const DeleteAccountDialog());
                  },
                  icon: AppAssets.vocabulary,
                  heading: 'Vocabulary',
                  content: result.vocabulary.feedback,
                ),
                ResultTile(
                  onTap: () async {
                    // Get.dialog(const DeleteAccountDialog());
                  },
                  icon: AppAssets.totalSpeakingTime,
                  heading: 'Total Speaking Time',
                  content: c.totalSpeakingTime.toString(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
