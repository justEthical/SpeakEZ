import 'package:flutter_svg/svg.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitButton extends StatelessWidget {
  final String title;
  final onTap;
  const SubmitButton({super.key, this.title = "Login", required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(Get.width - 40, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(width: 0.56, color: Colors.deepPurple),
        ),
        backgroundColor: Colors.white,
      ),
      child: Center(
        child: Text(
          title.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final OnboardingController c = Get.find<OnboardingController>();
        await c.googleLogin();
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(Get.width - 40, 50),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(width: 0.56, color: Colors.black),
        ),
        backgroundColor: Colors.black,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(AppAssets.google),
            ),
            const Text(
              "Login with Google",
              style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
