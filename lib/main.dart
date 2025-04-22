import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Controllers/global_controller.dart';
import 'Screens/tab_bar_screen.dart';

void main() {
  runApp(const AppEntry());
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(GlobalController());
      }),
      home: const TabBarScreen());
  }
}