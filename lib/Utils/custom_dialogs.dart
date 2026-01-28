import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/scenario_model.dart';
import 'package:speak_ez/Screens/HomeScreen/list_of_lessons.dart';
import 'package:speak_ez/Screens/Lessons/lesson_intro_screen.dart';
import 'package:speak_ez/Screens/Login/login_screen.dart';
import 'package:speak_ez/Screens/Practice/chat_screen.dart';
import 'package:speak_ez/Services/admob_service.dart';
import 'package:speak_ez/Services/auth_service.dart';
import 'package:speak_ez/Services/firestore_helper.dart';

class CustomDialogs {
  static Widget logoutDialog(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFF59E0B),
                size: 22,
              ),
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              AppStrings.logout.tr,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                fontFamily: AppStrings.nunitoFont,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 4),
            // Message
            Text(
              AppStrings.areYouSureLogout.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: AppStrings.nunitoFont,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    text: AppStrings.cancel.tr,
                    onPressed: () => Get.back(),
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DialogButton(
                    text: AppStrings.yes.tr,
                    onPressed: () async {
                      Get.delete<GlobalController>();
                      Get.put(GlobalController());
                      AuthService.logout();
                      await globalController.prefs?.clear();
                      globalController.prefs?.setString(
                        AppStrings.userAuthState,
                        "loggedOut",
                      );
                      Get.offAll(() => const LoginSignUp());
                    },
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget enablePermissionFromSettings(
    BuildContext context,
    String infoText,
  ) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.settings_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              AppStrings.openSettings.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                fontFamily: AppStrings.nunitoFont,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            // Message
            Text(
              infoText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: AppStrings.nunitoFont,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            // Button
            SizedBox(
              width: double.infinity,
              child: _DialogButton(
                text: AppStrings.openSettings.tr,
                onPressed: () {
                  globalController.openAppSetting();
                },
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget deleteConfirmationDialog(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFEF4444),
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              AppStrings.deleteAccount.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                fontFamily: AppStrings.nunitoFont,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            // Message
            Text(
              AppStrings.areYouSureDeleteAccount.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: AppStrings.nunitoFont,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    text: AppStrings.cancel.tr,
                    onPressed: () => Get.back(),
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DialogButton(
                    text: AppStrings.delete.tr,
                    onPressed: () async {
                      Get.delete<GlobalController>();
                      Get.put(GlobalController());
                      final res = await FirestoreHelper.deleteCurrentUser();
                      if (res) {
                        globalController.prefs?.setString(
                          AppStrings.userAuthState,
                          "loggedOut",
                        );
                        Get.offAll(() => const LoginSignUp());
                      }
                    },
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget levelIsLockedDialog(
    BuildContext context,
    String englishLevel,
    bool isLocked,
  ) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFF6366F1),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              '$englishLevel ${AppStrings.level.tr}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                fontFamily: AppStrings.nunitoFont,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            // Message
            Text(
              AppStrings.levelLockedMessage.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: AppStrings.nunitoFont,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    text: AppStrings.unlock.tr,
                    onPressed: () {
                      Get.back();
                      final timeDifference =
                          globalController.userProfile.value.unlockTestLastTime != null
                              ? DateTime.now()
                                  .difference(
                                    globalController.userProfile.value.unlockTestLastTime!,
                                  )
                                  .inHours
                              : 25;
                      if (timeDifference > 24) {
                        Get.to(
                          () => LessonIntroScreen(
                            englishLevel: englishLevel,
                            isUnlockTest: true,
                          ),
                        );
                      } else {
                        globalController.showSnackbarWithGetX(
                          AppStrings.unlockTest.tr,
                          "${AppStrings.canUnlockIn.tr} ${24 - timeDifference} ${AppStrings.hours.tr}",
                        );
                      }
                    },
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DialogButton(
                    text: AppStrings.view.tr,
                    onPressed: () {
                      Get.back();
                      Get.to(
                        () => ListOfLessons(
                          englishLevel: englishLevel,
                          isLessonLocked: isLocked,
                        ),
                      );
                    },
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget startPracticeDialog(
    BuildContext context,
    ScenarioModel scenarioModel,
  ) {
    final bool hasEnoughGems = globalController.userProfile.value.gems >= 100;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            // Gem animation or icon
            if (!hasEnoughGems)
              SizedBox(
                height: 80,
                width: 80,
                child: Lottie.asset(
                  AppAssets.gemAnimation,
                  repeat: true,
                  decoder: globalController.customDecoder,
                ),
              )
            else
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
              ),
            const SizedBox(height: 16),
            // Title
            Text(
              scenarioModel.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                fontFamily: AppStrings.nunitoFont,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            // Gems info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppAssets.gem, width: 18, height: 18),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      AppStrings.startingPracticeWillUse.tr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppStrings.nunitoFont,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Buttons
            if (!hasEnoughGems)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: _DialogButton(
                      text: AppStrings.watchAdGetGems.tr,
                      onPressed: () async {
                        Get.back();
                        GoogleMobileAdsService.instance.showRewarded(
                          onReward: (reward) {
                            
                              globalController.userProfile.value.gems += 100;
                              globalController.userProfile.refresh();
                              globalController.updateProfile();
                            
                          },
                        );
                      },
                      color: const Color(0xFF10B981),
                      icon: Icons.play_circle_outline_rounded,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            SizedBox(
              width: double.infinity,
              child: _DialogButton(
                text: AppStrings.start.tr,
                onPressed: hasEnoughGems
                    ? () {
                        Get.back();
                        Get.to(ChatScreen(scenarioModel: scenarioModel));
                      }
                    : null,
                color: Theme.of(context).colorScheme.primary,
                icon: Icons.arrow_forward_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final Color? color;
  final IconData? icon;

  const _DialogButton({
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.color,
    this.icon,
  });

  @override
  State<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<_DialogButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? Theme.of(context).colorScheme.primary;
    final isDisabled = widget.onPressed == null;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
      onTap: isDisabled
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onPressed?.call();
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: widget.isOutlined
              ? Colors.transparent
              : isDisabled
                  ? Colors.grey.shade300
                  : buttonColor,
          borderRadius: BorderRadius.circular(14),
          border: widget.isOutlined
              ? Border.all(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                  width: 1.5,
                )
              : null,
          boxShadow: widget.isOutlined || isDisabled
              ? null
              : [
                  BoxShadow(
                    color: buttonColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                size: 18,
                color: widget.isOutlined
                    ? Theme.of(context).textTheme.bodyMedium?.color
                    : isDisabled
                        ? Colors.grey
                        : Colors.white,
              ),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                widget.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppStrings.nunitoFont,
                  color: widget.isOutlined
                      ? Theme.of(context).textTheme.bodyMedium?.color
                      : isDisabled
                          ? Colors.grey
                          : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
