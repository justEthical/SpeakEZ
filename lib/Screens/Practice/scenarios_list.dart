import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/scenario_model.dart';
import 'package:speak_ez/Screens/Practice/Widgets/scenario_card.dart';
import 'package:speak_ez/Services/admob_service.dart';
import 'package:speak_ez/Services/posthog_service.dart';

class ScenariosList extends StatelessWidget {
  final ScenarioCategoryModel scenarioModel;
  const ScenariosList({super.key, required this.scenarioModel});

  @override
  Widget build(BuildContext context) {
    final scenarioList =
        AppData.scenarios
            .where((scenario) => scenario.category == scenarioModel.title)
            .toList();
    GoogleMobileAdsService.instance.loadRewarded(
      adUnitId: AppStrings.rewardedAdUnitId,
    );
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 150,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              titlePadding: const EdgeInsetsDirectional.only(
                start: 16,
                bottom: 0,
              ),
              background: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.deepPurple, Colors.blue],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => Text(
                              "GEMS: ${globalController.userProfile.value.gems}"
                                  .toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Image.asset(AppAssets.gem, width: 20, height: 20),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              PostHogService.instance.captureClick(
                                'practice_scenario_close',
                                elementType: 'button',
                                screenName: 'practice_scenario_screen',
                              );
                              Get.back();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Hero(
                            tag: scenarioModel.title,
                            child: Container(
                              width: 80,
                              height: 80,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade200,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.asset(scenarioModel.assetPath),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: Get.width - 114,
                            child: Text(
                              scenarioModel.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 15.0,
                ),
                child: ScenarioCard(scenarioModel: scenarioList[i]),
              );
            }, childCount: scenarioList.length),
          ),
        ],
      ),
    );
  }
}
