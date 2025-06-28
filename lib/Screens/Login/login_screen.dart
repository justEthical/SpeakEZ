import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => c.isloginForm.value
                  ? const TopText(
                      heading: "Welcome Back",
                      subHeading: "Glad to see you again")
                  : const TopText(
                      heading: "Let's Start",
                      subHeading: "Create your account in simple steps",
                    )),
              const SizedBox(
                height: 20,
              ),
              const LoginSignUpSwitch(),
              SizedBox(height: Get.height * 0.05,),
              Obx(() => c.isloginForm.value? LoginForm() : SignUpForm())
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
