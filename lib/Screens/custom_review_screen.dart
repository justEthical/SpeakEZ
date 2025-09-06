import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

class CustomReviewScreen extends StatelessWidget {
  const CustomReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.shade300,
            ),
            child: Icon(Icons.close, color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          children: [
            Lottie.asset(
              AppAssets.rating,
            
              decoder: globalController.customDecoder,
            ),
            Flexible(
              flex: 1,
              child: Text(
                "Please rate your experience",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 20),
            Flexible(
              flex: 1,
              child: Text(
                AppStrings.reviewRequest,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Spacer(),
            HighlightButton(),
          ],
        ),
      ),
    );
  }


}


class HighlightButton extends StatefulWidget {
  const HighlightButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HighlightButtonState createState() => _HighlightButtonState();
}

class _HighlightButtonState extends State<HighlightButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // blinking speed
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.deepPurple,
      end: Colors.deepPurple.shade700, // highlight color
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return ElevatedButton(
          onPressed: () {
            Get.back();
            globalController.openUrl(AppStrings.appPlayStoreUrl);
            globalController.userProfile.value.isShownCustomReviewDialogOnce = true;
            globalController.updateProfile();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _colorAnimation.value, // animate background
            fixedSize: Size(Get.width - 40, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Rate Us',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20
            ),
          ),
        );
      },
    );
  }
}

