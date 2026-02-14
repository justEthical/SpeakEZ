import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';

class LoginSignUpSwitch extends StatefulWidget {
  const LoginSignUpSwitch({super.key});

  @override
  State<LoginSignUpSwitch> createState() => _LoginSignUpSwitchState();
}

class _LoginSignUpSwitchState extends State<LoginSignUpSwitch> {
  // var c.isLogin.value.value = true;
  double switchButtonWidth = (Get.width - 50) / 2;

  final OnboardingController c = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        padding: const EdgeInsets.all(5),
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withValues(alpha: 0.2)),
        child: Stack(
          children: [
            SizedBox(
              height: 40,
              width: Get.width - 50,
            ),
            SizedBox(
              width: Get.width - 50,
              height: 40,
              child: Row(children: [
                _buttonBackgroundText(AppStrings.login.tr.tr),
                _buttonBackgroundText(AppStrings.register.tr.tr),
              ]),
            ),
            Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 40,
                  width: (Get.width - 50) / 2,
                  margin: EdgeInsets.only(
                      left: c.isloginForm.value ? 0 : switchButtonWidth,
                      right: !c.isloginForm.value ? 0 : switchButtonWidth),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.primary),
                  child: Center(
                      child: Text(
                    c.switchButtonText.value,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )),
                )),
          ],
        ));
  }

  Widget _buttonBackgroundText(String title) {
    return InkWell(
      onTap: () {
        c.isloginForm.value = !c.isloginForm.value;
        c.switchButtonText.value = c.isloginForm.value ? AppStrings.login.tr.tr : AppStrings.register.tr.tr;
        // setState(() {});
      },
      child: SizedBox(
        width: switchButtonWidth,
        height: 40,
        child: Center(
            child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w400),
        )),
      ),
    );
  }
}
