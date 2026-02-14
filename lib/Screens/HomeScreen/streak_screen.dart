import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

class StreakScreen extends StatelessWidget {
  final int? gems;
  const StreakScreen({super.key, this.gems});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final theme = Theme.of(context).textTheme.bodyMedium?.color;
    final profile = globalController.userProfile.value;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            /// --- Gems Earned ---
            gems != null ?  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _labelText(context, AppStrings.youGot.tr),
                _labelText(context, gems.toString()),
                Image.asset(AppAssets.gem, width: 20, height: 20),
              ],
            ): SizedBox(),

            SizedBox(
              width: Get.width / 3,
              height: Get.width / 3,
              child: Lottie.asset(
                AppAssets.streak,
                repeat: true,
                decoder: globalController.customDecoder,
              ),
            ),

            const SizedBox(height: 20),

            /// --- Streak Days ---
            Text(
              "${AppStrings.yourCurrentStreakIs.tr} ${profile.currentStreak} ${AppStrings.days.tr}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 20),

            /// --- Weekly Calendar ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                7,
                (i) {
                  final weekDate = AppData.getCurrentWeekDates()[i];
                  final today = DateTime(now.year, now.month, now.day);
                  final tileDate = DateTime(weekDate.year, weekDate.month, weekDate.day);
                  return _DayStreakTile(
                    date: weekDate,
                    completed: profile.weekDaysStreak.toMap().values.toList()[i],
                    isFuture: tileDate.isAfter(today),
                    isToday: tileDate.isAtSameMomentAs(today),
                    label: AppData.weekDaysName[i],
                  );
                },
              ),
            ),

            const Spacer(),

            /// --- Close Btn ---
            SafeArea(
              child: InkWell(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 0.4),
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                  ),
                  child: Text(
                    AppStrings.close.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppStrings.poppinsFont,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _labelText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// --- SINGLE DAY TILE WIDGET -----------------------------------------------
/// ---------------------------------------------------------------------------

class _DayStreakTile extends StatelessWidget {
  final DateTime date;
  final bool completed;
  final bool isFuture;
  final bool isToday;
  final String label;

  const _DayStreakTile({
    required this.date,
    required this.completed,
    required this.isFuture,
    required this.isToday,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final dayBoxSize = (Get.width - 80) / 7;

    return Column(
      children: [
        Container(
          width: dayBoxSize,
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isToday ? Colors.orange : Colors.grey,
              width: isToday ? 1.5 : 0.4,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppStrings.poppinsFont,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: isToday ? Colors.orange : null,
                ),
              ),

              const Spacer(),

              _buildStatusIcon(),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontFamily: AppStrings.poppinsFont,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday ? Colors.orange : null,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIcon() {
    if (completed) {
      // Completed day - show fire icon
      return SizedBox(
        width: 25,
        height: 25,
        child: Image.asset(AppAssets.fire),
      );
    } else if (isToday) {
      // Today but not completed - show empty circle (orange border indicates it's today)
      return Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.orange, width: 1.5),
          borderRadius: BorderRadius.circular(50),
        ),
      );
    } else if (isFuture) {
      // Future day - show transparent circle
      return Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey, width: 0.4),
          borderRadius: BorderRadius.circular(50),
        ),
      );
    } else {
      // Past day not completed - show grey filled circle
      return Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.3),
          border: Border.all(color: Colors.grey, width: 0.4),
          borderRadius: BorderRadius.circular(50),
        ),
      );
    }
  }
}
