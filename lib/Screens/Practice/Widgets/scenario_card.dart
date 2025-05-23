import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_assets.dart';

class ScenarioCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final String level;
  const ScenarioCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      padding: EdgeInsets.all(10),
      width: Get.width - 40,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(57, 0, 0, 0),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: SvgPicture.asset(AppAssets.jobInterview),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: Get.width - 220,
                child: Text(
                  subtitle,
                  maxLines: 10,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
