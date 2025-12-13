import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/SettingsScreen/Widgets/reauthentication_bottom_sheet.dart';
import 'package:speak_ez/Screens/SettingsScreen/Widgets/select_language.dart';
import 'package:speak_ez/Screens/SettingsScreen/Widgets/settings_option_tile.dart';
import 'package:speak_ez/Utils/common_widgets.dart';
import 'package:speak_ez/Utils/custom_dialogs.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';

class SettingScreens extends StatelessWidget {
  const SettingScreens({super.key});

  @override
  Widget build(BuildContext context) {
    PostHogService.instance.captureScreenView('settings_screen');
    PostHogService.instance.capture(PostHogEvents.settingsOpened);
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: Get.width,
            padding: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            // height: 250,
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        AppStrings.settings.tr,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontFamily: AppStrings.nunitoFont,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 18,
                        height: 30,
                        child: Image.asset(AppAssets.gem),
                      ),
                      SizedBox(width: 8),
                      Text(
                        globalController.userProfile.value.gems.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontFamily: AppStrings.nunitoFont,
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: UrlImage(url: _getImageUrl()),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Get.width - 140,
                            child: Text(
                              globalController.userProfile.value.displayName,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppStrings.nunitoFont,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: Get.width - 140,
                            child: Text(
                              globalController.userProfile.value.email,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppStrings.nunitoFont,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: SizedBox(
              height: Get.height - 275,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SettingsOptionTile(
                      onTap: () {
                        globalController.openUrl(
                          AppStrings.privacyPolicyUrl.tr,
                        );
                      },
                      heading: AppStrings.help.tr,
                      content: AppStrings.privacyPolicy.tr,
                      icon: AppAssets.helpCircle,
                    ),
                    SettingsOptionTile(
                      onTap: () {
                        globalController.openUrl(AppStrings.appPlayStoreUrl);
                      },
                      heading: AppStrings.rateUs.tr,
                      content: AppStrings.rateUsOnGooglePlay.tr,
                      icon: AppAssets.starIcon,
                    ),
                    SettingsOptionTile(
                      onTap: () async {
                        await SharePlus.instance.share(
                          ShareParams(
                            text:
                                '${AppStrings.appShareMessage}\n${AppStrings.appPlayStoreUrl}',
                          ),
                        );
                      },
                      heading: AppStrings.referToFriend.tr,
                      content: AppStrings.shareWithFriends.tr,
                      icon: AppAssets.giftIcon,
                    ),
                    SettingsOptionTile(
                      onTap: () async {
                        Get.defaultDialog(
                          titleStyle: const TextStyle(fontSize: 0),
                          content: CustomDialogs.logoutDialog(Get.context!),
                        );
                      },
                      icon: AppAssets.logOut,
                      content: AppStrings.logout.tr,
                    ),
                    SettingsOptionTile(
                      onTap: () async {
                        // Get.dialog(CustomDialogs.deleteConfirmationDialog());
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) {
                            return ReauthenticationBottomSheet();
                          },
                        );
                      },
                      icon: AppAssets.deleteIcon,
                      heading: AppStrings.deleteAccount.tr,
                      content: AppStrings.deleteAccountAndData.tr,
                    ),
                    SettingsOptionTile(
                      onTap: () async {
                        showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          builder: (ctx) => SelectLanguageBottomSheet(),
                        );
                      },
                      icon: AppAssets.appLanguage,
                      heading: "App Language",
                      content: _getLanguage(
                        globalController.userProfile.value.appLanguage,
                      ),
                    ),
                    SizedBox(height: 20),

                    Obx(
                      () => Text(
                        globalController.appVersion.value,
                        style: GoogleFonts.bebasNeue(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getImageUrl() {
    if (globalController.userProfile.value.photoUrl == '' ||
        globalController.userProfile.value.photoUrl == null) {
      return 'https://avatar.iran.liara.run/public';
    } else {
      return globalController.userProfile.value.photoUrl!;
    }
  }

  String _getLanguage(String langCode) {
    for (var lang in AppData.appLanguages) {
      if (lang.code == langCode) {
        return lang.language;
      }
    }
    return "English";
  }
}
