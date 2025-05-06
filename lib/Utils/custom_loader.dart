import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLoader {
  static void showLoader({String loader = ""}) {
    // Get.dialog(const SpinKitSquareCircle(color: ColorConstants.primaryColor));
    Get.dialog(
      PopScope(
        canPop: false,
        child:
            loader == ""
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : SizedBox(width: Get.width * 0.5, height: Get.width * 0.5),
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
