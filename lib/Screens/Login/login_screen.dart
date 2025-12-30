import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_ez/Screens/Login/Widgets/terms_and_privacy.dart';
import 'package:speak_ez/Screens/Login/Widgets/top_text.dart';

import 'Widgets/login_form.dart';
import 'Widgets/login_signup_switcher.dart';
import 'Widgets/signup_form.dart';

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({super.key});

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  final c = Get.find<OnboardingController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setFirstInstallFalse();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => c.isloginForm.value
                  ?  TopText(
                      heading: AppStrings.welcomeBack.tr,
                      subHeading: AppStrings.gladToSeeYouAgain.tr)
                  :  TopText(
                      heading: AppStrings.letsStart.tr,
                      subHeading: AppStrings.createAccountInSimpleSteps.tr,
                    )),
              const SizedBox(
                height: 15,
              ),
              const LoginSignUpSwitch(),
              const SizedBox(
                height: 15,
              ),
              Obx(() => c.isloginForm.value? LoginForm() : SignUpForm()),
              SizedBox(height: 15),
              TermsAndPrivacy()
            ],
          ),
        ),
      )),
    );
  }

  _setFirstInstallFalse()async{
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool("firstInstall", false);
  }
}
