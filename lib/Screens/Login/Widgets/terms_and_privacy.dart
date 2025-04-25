import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndPrivacy extends StatelessWidget {
  const TermsAndPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,

      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: <TextSpan>[
          const TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: const TextStyle(decoration: TextDecoration.underline),
            // You can add a tap gesture recognizer here to handle clicks
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    //   // Handle Terms of Service click
                    _launchUrl(AppStrings.termsAndConditionsUrl);
                  },
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(decoration: TextDecoration.underline),
            // You can add a tap gesture recognizer here to handle clicks
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    _launchUrl(AppStrings.privacyPolicyUrl);
                    //   // Handle Privacy Policy click
                  },
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  Future<void> _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $url');
    }
  }
}
