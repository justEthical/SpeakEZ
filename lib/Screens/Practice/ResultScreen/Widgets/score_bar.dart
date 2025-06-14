import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScoreBar extends StatelessWidget {
  final int score;
  const ScoreBar({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: 10,
          width: ((Get.width - 60) / 100) * score,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
    
        Container(
          width: Get.width - 60,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
