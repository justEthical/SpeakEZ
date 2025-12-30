import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';

class ExitAlertChatBottomSheet extends StatefulWidget {
  const ExitAlertChatBottomSheet({super.key});

  @override
  State<ExitAlertChatBottomSheet> createState() => _ExitAlertChatBottomSheetState();
}

class _ExitAlertChatBottomSheetState extends State<ExitAlertChatBottomSheet> {
  final c = Get.find<PracticeController>();
  @override
  void dispose() {
    super.dispose();
    c.isBottomSheetOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: EdgeInsets.all(15),
      color: Theme.of(context).scaffoldBackgroundColor,
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
            AppStrings.exitChatConfirmation.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 20,
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
              AppStrings.continueLearning.tr,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          SizedBox(height: 12),
          InkWell(
            onTap: () {
              globalController.userProfile.refresh();
              c.stopRecording();
              Get.back();
              Get.back();
            },
            child: Text(
              AppStrings.closeAndDiscard.tr,
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
