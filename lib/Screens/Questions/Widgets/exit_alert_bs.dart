import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/tab_bar_screen.dart';

class ExitAlertBottomSheet extends StatelessWidget {
  const ExitAlertBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Lottie.asset(
              AppAssets.exitAlert,
              decoder: globalController.customDecoder,
            ),
          ),
          Text(
            "Are you sure you want to exit and discard your lesson progress?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              fixedSize: Size(Get.width, 45),
            ),
            child: Text(
              "Continue learning",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 12),
          InkWell(
            onTap: () => Get.offAll(TabBarScreen()),
            child: Text(
              "Close and discard",
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
