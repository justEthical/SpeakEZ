import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Constants/category_styles.dart';
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
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.deepPurple, Colors.blue],
                ),
              ),
              child: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                "${AppStrings.gems.tr}: ${globalController.userProfile.value.gems}"
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Icon(
                                  categoryStyleForTitle(scenarioModel.title).icon,
                                  color: Colors.white,
                                  size: 40,
                                ),
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
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              return scenarioList.length - 1 == i
                  ? SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ScenarioCard(scenarioModel: scenarioList[i]),
                    ),
                  )
                  : Padding(
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
