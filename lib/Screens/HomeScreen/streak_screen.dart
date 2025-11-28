import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

class StreakScreen extends StatefulWidget {
  final int gems;
  const StreakScreen({super.key, required this.gems});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You got: ",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.gems.toString(),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Image(image: AssetImage(AppAssets.gem), width: 20, height: 20),
              ],
            ),
            SizedBox(
              width: Get.width / 3,
              height: Get.width / 3,
              child: Lottie.asset(
                AppAssets.streak,
                repeat: true,
                decoder: globalController.customDecoder,
              ),
            ),
            SizedBox(height: 20, width: Get.width),
            Text(
              "Your current Streak is ${globalController.userProfile.value.currentStreak} days",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...List.generate(7, (i) {
                  return Column(
                    children: [
                      Container(
                        width: (Get.width - 80) / 7,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 0.4),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 3),
                            Text(
                              AppData.getCurrentWeekDates()[i].day.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppStrings.poppinsFont,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 3),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 5.0,
                              ),
                              child: Image.asset(AppAssets.fire),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        AppData.weekDaysName[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: AppStrings.poppinsFont,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey, width: 0.4),
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Text(
                  "Close",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: AppStrings.poppinsFont,
                    fontWeight: FontWeight.normal,
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
