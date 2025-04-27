import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/SettingsScreen/Widgets/settings_option_tile.dart';

class SettingScreens extends StatelessWidget {
  const SettingScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: Get.width,
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
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(width: 20),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            globalController.userProfile.value.imageUrl,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Spacer(),
                          Text(
                            globalController.userProfile.value.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppStrings.nunitoFont,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            globalController.userProfile.value.email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppStrings.nunitoFont,
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              fixedSize: Size(100, 30),
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                            ),
                            child: Text(
                              "Edit",
                              style: TextStyle(color: Colors.white),
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
                    // Get.to(AboutUsAndPrivacy());
                  },
                  heading: "Help",
                  content: "About Us & Privacy Policy",
                  icon: AppAssets.helpCircle,
                ),
                SettingsOptionTile(
                  onTap: () {},
                  heading: "Rate Us",
                  content: "Rate us on Google play",
                  icon: AppAssets.starIcon,
                ),
                SettingsOptionTile(
                  onTap: () {},
                  heading: "Refer to Friend",
                  content: "Share karo apne dosto ko",
                  icon: AppAssets.giftIcon,
                ),
                SettingsOptionTile(
                  onTap: () async {
                    // Get.defaultDialog(
                    //     titleStyle: const TextStyle(fontSize: 0),
                    //     content: const LogoutDialog());
                  },
                  icon: AppAssets.logOut,
                  content: "Logout",
                ),
                SettingsOptionTile(
                  onTap: () async {
                    // Get.dialog(const DeleteAccountDialog());
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
}
