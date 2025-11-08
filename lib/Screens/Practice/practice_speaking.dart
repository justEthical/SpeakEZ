import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Utils/whisper_helper.dart';

import 'scenarios_list.dart';

class PracticeSpeaking extends StatefulWidget {
  const PracticeSpeaking({super.key});

  @override
  State<PracticeSpeaking> createState() => _PracticeSpeakingState();
}

class _PracticeSpeakingState extends State<PracticeSpeaking> {
  final PracticeController c = Get.put(PracticeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!globalController.isAiModelDownloaded.value) {
        WhisperHelper.isModelAvailable().then((isAvailable) {
          globalController.isAiModelDownloaded.value = isAvailable;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            const SizedBox(height: 20),
            Expanded(
              child: ScenarioCategoryGrid()
              // Obx(
              //   () =>
                    // globalController.isAiModelDownloaded.value
                    //     ? 
                        // ScenarioCategoryGrid() 
                        // : const _DownloadingState(),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScenarioCategoryGrid extends StatelessWidget {
  const ScenarioCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: List.generate(
          AppData.scenarioCategories.length,
          (index) => Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              onTap: () {
                Get.to(ScenariosList(scenarioModel: AppData.scenarioCategories[index],));
              },
              child: Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Hero(
                        tag: AppData.scenarioCategories[index].title,
                        child: Image.asset(
                          AppData.scenarioCategories[index].assetPath,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      AppData.scenarioCategories[index].title,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  _Header();

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    final isShowPracticeTabInfoBanner =
        globalController.prefs?.getBool(
          AppStrings.isShowPracticeTabInfoBanner,
        ) ??
        true;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Speaking Practice",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              fontFamily: AppStrings.nunitoFont,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          SizedBox(height: isShowPracticeTabInfoBanner ? 15 : 0),
          isShowPracticeTabInfoBanner
              ? Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: Icon(
                            Icons.rocket_launch_rounded,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Practice with Natasha",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  fontFamily: AppStrings.nunitoFont,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Select a scenario to start practicing.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  fontFamily: AppStrings.nunitoFont,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        globalController.prefs?.setBool(
                          AppStrings.isShowPracticeTabInfoBanner,
                          false,
                        );
                        setState(() {});
                      },
                    ),
                  ),
                ],
              )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class _DownloadingState extends StatelessWidget {
  const _DownloadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              AppAssets.downloading,
              width: Get.width * 0.4,
              height: Get.width * 0.4,
              decoder: globalController.customDecoder,
            ),
            const SizedBox(height: 20),
            Text(
              "Downloading Natasha AI…",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 20,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Text(
                "The download is about 60 MB. Please keep the app open. (${globalController.aiModelDownloadProgress.value.toStringAsFixed(0)}%)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppStrings.nunitoFont,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: LinearProgressIndicator(
                  value: globalController.aiModelDownloadProgress.value / 100,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
