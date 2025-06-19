import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Screens/tab_bar_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  /// A widget that displays a result screen.
  /// The widget contains a stack with confetti at the background.
  /// There is a text with the result at the top, and a column
  /// at the bottom with an owl animation, a container with a
  /// percentage and a button at the end.
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    c.updateLesssonProgress();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: Get.width,
              height: Get.height,
              child: Lottie.asset(
                AppAssets.confetti,
                decoder: globalController.customDecoder,
                repeat: false,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              bottom: 20,
              left: 15,
              child: SafeArea(
                child: SizedBox(
                  height: Get.height,
                  child: Column(
                    children: [
                      Spacer(flex: 10),
                      Text(
                        "Lesson Completed",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(flex: 10),
                      SizedBox(
                        width: Get.width - 30,
                        child: Text(
                          c.getResultScreenText(96.6),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Spacer(flex: 5),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Lottie.asset(
                          AppAssets.owl,
                          decoder: globalController.customDecoder,
                          repeat: true,
                        ),
                      ),
                      Spacer(flex: 10),
                      Container(
                        width: Get.width - 30,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Spacer(),

                            Text(
                              "96.4%",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: Get.width - 30,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(18),
                                  bottomRight: Radius.circular(18),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "YourAccuracy",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Get.offAll(() => const TabBarScreen()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          fixedSize: Size(Get.width - 30, 55),
                        ),
                        child: Text(
                          "Done",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
