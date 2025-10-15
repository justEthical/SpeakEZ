import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/list_of_lessons.dart';
import 'package:speak_ez/Screens/Lessons/lesson_intro_screen.dart';
import 'package:speak_ez/Screens/Login/login_screen.dart';
import 'package:speak_ez/Services/auth_service.dart';
import 'package:speak_ez/Services/firestore_helper.dart';

class CustomDialogs {
  static Widget logoutDialog(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        // padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const Text(
              'Are you sure you want to logout?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    AuthService.logout();
                    await globalController.prefs?.clear();
                    globalController.prefs?.setString(
                      AppStrings.userAuthState,
                      "loggedOut",
                    );
                    Get.offAll(() => const LoginSignUp());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Yes'),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget enablePermissionFromSettings(BuildContext context, String infoText) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        // padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor  ,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
             Text(
              infoText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                globalController.openAppSetting();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Open Settings",
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget deleteConfirmationDialog(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Are you sure you want to delete your account?\n\nThis action is irreversible.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final res = await FirestoreHelper.deleteCurrentUser();
                    if (res) {
                      globalController.prefs?.setString(
                        AppStrings.userAuthState,
                        "loggedOut",
                      );
                      Get.offAll(() => const LoginSignUp());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Delete'),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget levelIsLockedDialog(BuildContext context, String englishLevel, bool isLocked) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: () => Get.back(),
                  child: Icon(Icons.close, size: 18),
                ),
              ],
            ),
            const Text(
              'This level is locked. You need to complete the previous level(s) to unlock this one or unlock it by giving a test.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    final timeDifference = globalController
                            .userProfile.value.unlockTestLastTime != null ?
                        DateTime.now()
                            .difference(
                              globalController
                                  .userProfile
                                  .value
                                  .unlockTestLastTime!,
                            )
                            .inHours : 25;
                    if (timeDifference > 24) {
                      Get.to(
                        () => LessonIntroScreen(
                          englishLevel: englishLevel,
                          isUnlockTest: true,
                        ),
                      );
                    } else {
                      globalController.showSnackbarWithGetX(
                        "Unlock test",
                        "You can unlock this level in ${24 - timeDifference} hours.",
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: const Size(106, 40),
                  ),
                  child: Text(
                    'UNLOCK',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.to(
                      () => ListOfLessons(
                        englishLevel: englishLevel,
                        isLessonLocked: isLocked,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: const Size(106, 40),
                  ),
                  child: Text(
                    'View',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
