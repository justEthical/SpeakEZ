import 'package:flutter/material.dart';
import 'package:speak_ez/Constants/app_strings.dart';

class TopText extends StatelessWidget {
  final String heading;
  final String subHeading;
  const TopText({super.key, required this.heading, required this.subHeading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.black),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          subHeading,
          style: const TextStyle(
              fontSize: 15,
              color: Colors.brown,
              fontWeight: FontWeight.w600,
              fontFamily: AppStrings.nunitoFont),
        ),
      ],
    );
  }
}
