import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';

class LessonsExitAlertBottomSheet extends StatefulWidget {
  const LessonsExitAlertBottomSheet({super.key});

  @override
  State<LessonsExitAlertBottomSheet> createState() =>
      _LessonsExitAlertBottomSheetState();
}

class _LessonsExitAlertBottomSheetState
    extends State<LessonsExitAlertBottomSheet> {
  final c = Get.find<QuestionOptionsController>();

  @override
  void dispose() {
    super.dispose();
    c.isBottomSheetOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Lottie.asset(
              AppAssets.exitAlert,
              decoder: globalController.customDecoder,
            ),
          ),
          Text(
            c.isUnlockTest
                ? "⚠️ Exiting will immediately end this test. You will not be able to attempt any UNLOCK LEVEL TEST again until 24 hours have passed. Do you still want to Exit?"
                : "Are you sure you want to exit and discard your current lessson's progress?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: c.isUnlockTest ? 16 : 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              fixedSize: Size(Get.width, 45),
            ),
            child: Text(
              c.isUnlockTest ? "Continue Test" : "Continue learning",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          SizedBox(height: 12),
          InkWell(
            onTap: () {
              Get.back();
              Get.back();
              Get.delete<QuestionOptionsController>(force: true);
            },
            child: Text(
              "Exit and Discard",
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
