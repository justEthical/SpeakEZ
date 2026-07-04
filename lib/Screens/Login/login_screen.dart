import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Constants/posthog_events.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({super.key});

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  final c = Get.find<OnboardingController>();

  @override
  void initState() {
    super.initState();
    _setFirstInstallFalse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF201538),
              Color(0xFF2C2050),
              Color(0xFF6B5C37),
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Hero image
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    AppAssets.welcomeHero,
                    fit: BoxFit.cover,
                  ),
                ),
                // Title + tagline + subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF9B6BFF),
                          Color(0xFFC77BC0),
                          Color(0xFFE0872F),
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        "SpeakEZ AI",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.loginTagline.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      AppStrings.masterEnglishSubtitle.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
                // Button + divider + terms
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _GoogleButton(onTap: () async {
                      PostHogService.instance.capture(
                        PostHogEvents.buttonClicked,
                        properties: {
                          'button_name': 'google_login',
                          'element_type': 'google_login_button',
                          'screen_name': 'login_screen',
                        },
                      );
                      await c.googleLogin();
                    }),
                    const SizedBox(height: 20),
                    Divider(
                        color: Colors.white.withValues(alpha: 0.2), thickness: 1),
                    const SizedBox(height: 16),
                    const _TermsText(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _setFirstInstallFalse() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("firstInstall", false);
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: 13,
          height: 1.4,
          color: Colors.white.withValues(alpha: 0.6),
        ),
        children: <TextSpan>[
          TextSpan(text: AppStrings.byContinuingYouAgree.tr),
          TextSpan(
            text: AppStrings.termsOfService.tr,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchUrl(AppStrings.termsAndConditionsUrl),
          ),
          TextSpan(text: AppStrings.and.tr),
          TextSpan(
            text: AppStrings.privacyPolicy.tr,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchUrl(AppStrings.privacyPolicyUrl),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
}

class _GoogleButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GoogleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.google, height: 24, width: 24),
            const SizedBox(width: 14),
            Text(
              AppStrings.continueWithGoogle.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
