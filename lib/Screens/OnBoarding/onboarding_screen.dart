import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Models/onboarding_view_model.dart';
import 'package:speak_ez/Screens/Login/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController c = Get.put(OnboardingController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              SmoothPageIndicator(
                controller:
                    c.onboardingPageIndicator, // PageController
                count: 3,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.blue,
                  radius: 8,
                  dotWidth: 12,
                  dotHeight: 12,
                ), // your preferred effect
                onDotClicked: (index) {},
              ),
              SizedBox(height: 40),
              Expanded(
                child: PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  controller: c.onboardingPageIndicator,
                  scrollDirection: Axis.horizontal,
                  itemCount: onBoardingItems.length,
                  itemBuilder: (ctx, i) {
                    return Column(
                      children: [
                        Spacer(flex: 2),
                        SizedBox(
                          width: Get.width * 0.8,
                          height: Get.width * 0.8,
                          child: Lottie.asset(
                            onBoardingItems[i].lottieAnimation,
                            decoder: globalController.customDecoder,
                          ),
                        ),
                        Spacer(flex: 2),
                        Text(
                          onBoardingItems[i].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: AppStrings.nunitoFont,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          onBoardingItems[i].description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: AppStrings.nunitoFont,
                          ),
                        ),
                        Spacer(flex: 1),
                      ],
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Obx(
                    () =>
                        (c.currentOnboardingIndex.value != 0)
                            ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(100, 40),
                              ),
                              onPressed: () {
                                c.currentOnboardingIndex.value--;
                                c.onboardingPageIndicator
                                    .previousPage(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.easeIn,
                                    );
                              },
                              child: Text(
                                "Previous",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                            : SizedBox(),
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(100, 40),
                    ),
                    onPressed: () {
                      c.onboardingPageIndicator.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                      if (c.currentOnboardingIndex.value == 2) {
                        globalController.prefs?.setString(AppStrings.userAuthState, "loggedOut");
                        Get.offAll(() => const LoginScreen());
                      }
                      c.currentOnboardingIndex.value++;
                    },
                    child: Text("Next", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
