import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

class SelectLanguageBottomSheet extends StatelessWidget {
  const SelectLanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Select Language",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          for (var lang in AppData.appLanguages)
            ListTile(
              onTap: () {
                Get.updateLocale(Locale(lang.code));
                globalController.userProfile.value.appLanguage = lang.code;
                globalController.updateProfile();
                Get.back();
              },
              leading: Text(lang.flag),
              title: Text(lang.language),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
