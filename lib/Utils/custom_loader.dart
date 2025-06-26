import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';

import '../Controllers/global_controller.dart';

class CustomLoader {
  var isLoaderOpen = false; 
  static void showLoader({String loader = ""}) {
    // Get.dialog(const SpinKitSquareCircle(color: ColorConstants.primaryColor));
    Get.dialog(
      PopScope(
        canPop: false,
        child: SizedBox(
          height: 50,
          width: 50,
          child: Lottie.asset(
            AppAssets.loader,
            repeat: true,
            decoder: globalController.customDecoder,
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoader() {
    if (Get.isDialogOpen!) {
      Get.back();

    }
  }
}
