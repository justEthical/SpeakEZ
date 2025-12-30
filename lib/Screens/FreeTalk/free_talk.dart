import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Constants/posthog_events.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Utils/custom_dialogs.dart';

class FreeTalk extends StatefulWidget {
  const FreeTalk({super.key});

  @override
  State<FreeTalk> createState() => _FreeTalkState();
}

class _FreeTalkState extends State<FreeTalk> {
  final c = Get.find<PracticeController>();

  @override
  void initState() {
    super.initState();
    PostHogService.instance.captureScreenView('free_talk_screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.freeTalk.tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontFamily: AppStrings.nunitoFont,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 30,
                  child: Image.asset(AppAssets.gem),
                ),
                SizedBox(width: 6),
                Obx(
                  () => Text(
                    globalController.userProfile.value.gems.toString(),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Spacer(),
          SizedBox(
            width: Get.width / 2,
            height: Get.width / 2,
            child: Lottie.asset(
              AppAssets.freeTalk,
              decoder: globalController.customDecoder,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              AppStrings.freeTalkDescription.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppStrings.nunitoFont,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              PostHogService.instance.capture(
                PostHogEvents.freeTalkStarted,
                properties: {'screen_name': 'free_talk_screen'},
              );
              final scenarioModel = c.getFreeTalkScenario();
              final status = await c.getMicrophonePermission(scenarioModel);
              if (!mounted) return;
              if (status) {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return CustomDialogs.startPracticeDialog(
                      context,
                      scenarioModel,
                    );
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              fixedSize: Size(Get.width - 40, 50),
            ),
            child: Text(
              AppStrings.startFreeTalk.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
