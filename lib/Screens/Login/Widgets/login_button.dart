import 'package:flutter/material.dart';
import 'package:speak_ez/Constants/app_strings.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final String logo;
  final onTap;
  const LoginButton({super.key, required this.logo, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.black,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Spacer(),
            SizedBox(width: 30, height: 30, child: Image.asset(logo)),
            SizedBox(width: 20),
            Text(
              "Sign in with $text",
              style: TextStyle(
                fontFamily: AppStrings.nunitoFont,
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
