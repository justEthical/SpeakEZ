import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Result",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share_rounded),
            onPressed: () async {
              CustomLoader.showLoader();
              await c.captureAndShare(globalKey);
              CustomLoader.hideLoader();
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: RepaintBoundary(
          key: globalKey,
          child: Container(
            padding: const EdgeInsets.all(15.0),
            color: const Color.fromARGB(255, 226, 226, 226)
            ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // PracticeAppBar(),
                // SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Text(
                        c.formatDateToLongString(DateTime.now()),
                        style: TextStyle(fontSize: 14, color: Colors.deepPurple),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Score: ${result.score}/100",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
          
                      SizedBox(height: 5),
                      ScoreBar(score: result.score),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
          
                Container(
                  margin: EdgeInsets.only(bottom: 10, top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Text(
                    result.motivation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
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
                  content: '${c.formatDuration(c.totalSpeakingTime)} Minutes',
                ),
                ResultTile(
                  onTap: () async {
                    // Get.dialog(const DeleteAccountDialog());
                  },
                  icon: AppAssets.tip,
                  heading: 'Suggestion',
                  content: result.suggestion,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
