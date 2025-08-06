import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/SettingsScreen/Widgets/reauthentication_bottom_sheet.dart';
import 'package:speak_ez/Screens/SettingsScreen/Widgets/settings_option_tile.dart';
import 'package:speak_ez/Services/appwrite_service.dart';
import 'package:speak_ez/Utils/common_widgets.dart';
import 'package:speak_ez/Utils/custom_dialogs.dart';

class SettingScreens extends StatelessWidget {
  const SettingScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: Get.width,
            padding: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
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
                        "Settings",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: AppStrings.nunitoFont,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.deepPurple,
                          ),
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
                          color: Colors.white,
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
                                color: Colors.white,
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
                                color: Colors.white,
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
            child: Column(
              children: [
                SettingsOptionTile(
                  onTap: () {
                    globalController.openUrl(AppStrings.privacyPolicyUrl);
                    // Get.to(AboutUsAndPrivacy());
                  },
                  heading: "Help",
                  content: "Privacy Policy",
                  icon: AppAssets.helpCircle,
                ),
                SettingsOptionTile(
                  onTap: () {},
                  heading: "Rate Us",
                  content: "Rate us on Google play",
                  icon: AppAssets.starIcon,
                ),
                SettingsOptionTile(
                  onTap: () {
                    AppwriteService().getLessons(level: 'A1');  
                  },
                  heading: "Refer to Friend",
                  content: "Share karo apne dosto ko",
                  icon: AppAssets.giftIcon,
                ),
                SettingsOptionTile(
                  onTap: () async {
                    Get.defaultDialog(
                      titleStyle: const TextStyle(fontSize: 0),
                      content: CustomDialogs.logoutDialog(),
                    );
                  },
                  icon: AppAssets.logOut,
                  content: "Logout",
                ),
                SettingsOptionTile(
                  onTap: () async {
                    // Get.dialog(CustomDialogs.deleteConfirmationDialog());
                    showModalBottomSheet(context: context,
                    isScrollControlled: true,
                     builder: (ctx){
                      return ReauthenticationBottomSheet();
                    });
                  },
                  icon: AppAssets.deleteIcon,
                  heading: 'Delete Account',
                  content: 'Delete account and data',
                ),
                SizedBox(height: 20),
                Obx(
                  () => Text(
                    globalController.appVersion.value,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ],
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
}
