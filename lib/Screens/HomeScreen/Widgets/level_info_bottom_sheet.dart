import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:speak_ez/Constants/app_strings.dart';

class LevelBottomSheet extends StatelessWidget {
  const LevelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                AppStrings.learnByLevel.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(Icons.close, color: Theme.of(context).colorScheme.onPrimary, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
           LevelItem(
            level: 'A1',
            title: AppStrings.a1Beginner.tr,
            description: AppStrings.a1Description.tr,
            color: Color(0xFF4D8B6F),
          ),
          const SizedBox(height: 16),
           LevelItem(
            level: 'A2',
            title: AppStrings.a2Elementary.tr,
            description: AppStrings.a2Description.tr,
            color: Color(0xFF4D8B6F),
          ),
          const SizedBox(height: 16),
           LevelItem(
            level: 'B1',
            title: AppStrings.b1Intermediate.tr,
            description: AppStrings.b1Description.tr,
            color: Color(0xFF5875A6),
          ),
          const SizedBox(height: 16),
           LevelItem(
            level: 'B2',
            title: AppStrings.b2UpperIntermediate.tr,
            description: AppStrings.b2Description.tr,
            color: Color(0xFF5875A6),
          ),
           const SizedBox(height: 16),
           LevelItem(
            level: 'C1',
            title: AppStrings.c1Advanced.tr,
            description: AppStrings.c1Description.tr,
            color: Color(0xFFAA8B56),
          ),
          const SizedBox(height: 16),
           LevelItem(
            level: 'C2',
            title: AppStrings.c2Expert.tr,
            description: AppStrings.c2Description.tr,
            color: Color(0xFFAA8B56),
          ),
        ],
      ),
    );
  }
}

class LevelItem extends StatelessWidget {
  final String level;
  final String title;
  final String description;
  final Color color;

  const LevelItem({
    super.key,
    required this.level,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              level,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
