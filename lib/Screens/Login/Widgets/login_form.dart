import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Screens/Login/Widgets/Or_separator.dart';
import 'package:speak_ez/Screens/Login/Widgets/custom_text_field.dart';
import 'package:speak_ez/Screens/Login/Widgets/login_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});
  final OnboardingController c = Get.find();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: c.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              textCtrl: c.emailController,
              hintText: "Enter Email...",
              leadingIcon: AppAssets.atIcon,
              title: "Email",
              isPassword: false,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              textCtrl: c.passwordController,
              hintText: "Enter password...",
              leadingIcon: AppAssets.lockIcon,
              title: "Password",
              isPassword: true,
            ),
            const SizedBox(
              height: 40,
            ),
            SubmitButton(
              onTap: () async {
                if (c.loginFormKey.currentState!.validate()) {
                  c.emailLogin(c.emailController.text.trim(), c.passwordController.text.trim());
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const OrSeparator(),
            const SizedBox(
              height: 20,
            ),
            const GoogleLoginButton()
          ],
        ));
  }
}
