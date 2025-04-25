import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Screens/Login/Widgets/login_button.dart';
import 'package:speak_ez/Screens/Login/Widgets/terms_and_privacy.dart';
import 'package:speak_ez/Services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.deepPurpleAccent, Colors.deepPurple],
          ),
        ),
        child: Column(
          children: [
            Spacer(),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x33000000),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(AppAssets.logo),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "SpeakEZ AI",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Connecting you to a world of English learning opportunities.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFamily: AppStrings.nunitoFont,
              ),
            ),
            Spacer(),

            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: SafeArea(
                child: Column(
                  children: [
                    Text(
                      "Join us to unlock your English potential \n login to continue.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: 20),
                    LoginButton(text: "Google", logo: AppAssets.google, onTap: () => AuthService.signInWithGoogle(),),
                    // SizedBox(height: 15),
                    // LoginButton(text: "Facebook", logo: AppAssets.fb),
                    SizedBox(height: 15),
                    TermsAndPrivacy(),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
