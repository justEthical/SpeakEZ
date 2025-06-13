import 'package:flutter/material.dart';

class PracticeAppBar extends StatelessWidget {
  const PracticeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            // Get.back();
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[300],
            ),
            child: Center(child: Icon(Icons.close, color: Colors.black)),
          ),
        ),
        Spacer(),
        Text(
          "Result",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            // Get.back();
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[300],
            ),
            child: Center(
              child: Icon(Icons.share_rounded, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
