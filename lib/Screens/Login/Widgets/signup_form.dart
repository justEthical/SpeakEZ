import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Screens/Login/Widgets/Or_separator.dart';
import 'package:speak_ez/Screens/Login/Widgets/custom_text_field.dart';
import 'package:speak_ez/Screens/Login/Widgets/login_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm({super.key});
  final OnboardingController c = Get.find();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: c.signupFormKey,
      child: Column(
        children: [
          CustomTextField(
            textCtrl: c.nameController,
            hintText: "Full Name",
            leadingIcon: AppAssets.user,
            title: "Full Name ",
            isPassword: false,
            keyBoardType: TextInputType.name,
          ),
          _gap(),
          CustomTextField(
            textCtrl: c.emailController,
            hintText: "Email",
            leadingIcon: AppAssets.atIcon,
            title: "Email",
            isPassword: false,
            keyBoardType: TextInputType.emailAddress,
          ),
          _gap(),
          CustomTextField(
            textCtrl: c.passwordController,
            hintText: "Password",
            leadingIcon: AppAssets.lockIcon,
            title: "Password",
            isPassword: true,
          ),
          CustomTextField(
            textCtrl: c.confirmPasswordController,
            hintText: "Confirm Password",
            leadingIcon: AppAssets.lockIcon,
            title: "Confirm Password",
            isPassword: true,
          ),

          _gap(val: 20),
          SubmitButton(
            title: "Register",
            onTap: () async {
              if (c.signupFormKey.currentState!.validate()) {
                c.emailSignUp(
                  c.emailController.text.trim(),
                  c.confirmPasswordController.text,
                  c.nameController.text.trim().capitalize!,
                );
              }
            },
          ),
          _gap(),
          const OrSeparator(),
          _gap(),
          const GoogleLoginButton(),
        ],
      ),
    );
  }

  _gap({double val = 10}) {
    return SizedBox(height: val);
  }
}
