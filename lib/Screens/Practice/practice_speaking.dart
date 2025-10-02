import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Models/scenario_model.dart';
import 'package:speak_ez/Screens/Practice/Widgets/scenario_card.dart';
import 'package:speak_ez/Utils/whisper_helper.dart';

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
            const _Header(),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() => globalController.isAiModelDownloaded.value
                  ? const _ScenarioList()
                  : const _DownloadingState()),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Speaking Practice",
            style: GoogleFonts.nunito(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.rocket_launch_rounded, color: Theme.of(context).colorScheme.onPrimary),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Practice with Natasha",
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Select a scenario to start practicing.",
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenarioList extends StatelessWidget {
  const _ScenarioList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: scenarios.length,
      itemBuilder: (ctx, i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: ScenarioCard(
            scenarioModel: scenarios[i],
          ),
        );
      },
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
              style: GoogleFonts.nunito(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => Text(
                  "The download is about 60 MB. Please keep the app open. (${globalController.aiModelDownloadProgress.value.toStringAsFixed(0)}%)",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            const SizedBox(height: 20),
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: LinearProgressIndicator(
                    value: globalController.aiModelDownloadProgress.value / 100,
                    backgroundColor: Colors.grey.shade300,
                    valueColor:  AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}