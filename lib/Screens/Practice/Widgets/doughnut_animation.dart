import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';

class AnimatedDoughnut extends StatefulWidget {
  const AnimatedDoughnut({super.key});

  @override
  State<AnimatedDoughnut> createState() => _AnimatedDoughnutState();
}

class _AnimatedDoughnutState extends State<AnimatedDoughnut>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  final PracticeController c = Get.find<PracticeController>();
  String get remainingSecondsText {
    final secondsLeft = (30 * _animation.value).ceil();
    return secondsLeft.toString();
  }

  @override
  void initState() {
    super.initState();
    c.recordingAnimationcontroller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    c.lottieAnimationcontroller = AnimationController(
      vsync: this,

    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(c.recordingAnimationcontroller)..addListener(() {
      setState(() {});
    });

    c.recordingAnimationcontroller.forward();
  }

  @override
  void dispose() {
    c.recordingAnimationcontroller.dispose();
    c.lottieAnimationcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: DoughnutPainter(progress: _animation.value),
          size: const Size(80, 80),
        ),
        Lottie.asset(
          AppAssets.recording,
          controller: c.lottieAnimationcontroller,
          onLoaded: (composition) {
            c.lottieAnimationcontroller
              ..duration = composition.duration
              ..repeat(); // or .forward()
          },
          width: 65,
          height: 65,
          repeat: true,
          decoder: globalController.customDecoder,
        ),
      ],
    );
  }
}

class DoughnutPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color fillColor;

  DoughnutPainter({
    required this.progress,
    this.backgroundColor = Colors.grey,
    this.fillColor = Colors.blue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 10.0;
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final foregroundPaint =
        Paint()
          ..color = fillColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Draw base ring
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw animated arc
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(DoughnutPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
