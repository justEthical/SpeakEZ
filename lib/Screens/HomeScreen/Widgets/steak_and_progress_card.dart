import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SteakAndProgressCard extends StatelessWidget {
  final String title;
  final String icon;
  final Color iconColor;
  final String progress;
  const SteakAndProgressCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 2 - 25,
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        // border: Border.all(color: Color.grey, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 5),
                width: 30,
                height: 30,
                child: SvgPicture.asset(
                  icon,
                  color: iconColor,
                ),
              ),
              SizedBox(width: 10),
              Text(
                progress,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
