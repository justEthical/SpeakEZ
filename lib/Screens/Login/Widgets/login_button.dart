import 'package:flutter_svg/svg.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';

class SubmitButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const SubmitButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        PostHogService.instance.captureClick(
          title,
          elementType: 'submit_button',
          screenName: 'login_screen',
        );
        onTap?.call();
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(Get.width - 40, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side:  BorderSide(width: 0.56, color: Theme.of(context).colorScheme.primary),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Center(
        child: Text(
          title.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.primary,
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
    final c = Get.find<OnboardingController>();
    return ElevatedButton(
      onPressed: () async {
        PostHogService.instance.capture(
          PostHogEvents.buttonClicked,
          properties: {
            'button_name': 'google_login',
            'element_type': 'google_login_button',
            'screen_name': 'login_screen',
          },
        );
        final OnboardingController c = Get.find<OnboardingController>();
        await c.googleLogin();
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(Get.width - 40, 50),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(width: 0.56, color: Colors.black),
        ),
        backgroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(AppAssets.google),
            ),
             Text(
              "${c.isloginForm.value ? AppStrings.login.tr.tr : AppStrings.register.tr.tr} with Google",
              style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.w600,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
