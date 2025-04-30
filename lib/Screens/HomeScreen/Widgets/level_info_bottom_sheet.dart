import 'package:flutter/material.dart';

class LevelBottomSheet extends StatelessWidget {
  const LevelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Learn by Level',
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
                  child: Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const LevelItem(
            level: 'A1',
            title: 'A1 Beginner',
            description: 'Start learning the language',
            color: Color(0xFF4D8B6F),
          ),
          const SizedBox(height: 16),
          const LevelItem(
            level: 'A2',
            title: 'A2 Elementary',
            description: 'Can communicate using simple sentences',
            color: Color(0xFF4D8B6F),
          ),
          const SizedBox(height: 16),
          const LevelItem(
            level: 'B1',
            title: 'B1 Intermediate',
            description: 'Can describe scenes and express thoughts coherently',
            color: Color(0xFF5875A6),
          ),
          const SizedBox(height: 16),
          const LevelItem(
            level: 'B2',
            title: 'B2 Upper-Intermediate',
            description:
                'Can understand complex texts and express ideas effortlessly',
            color: Color(0xFF5875A6),
          ),
          const SizedBox(height: 16),
          const LevelItem(
            level: 'C1',
            title: 'C1 Advanced',
            description: 'Can communicate fluently with native speakers',
            color: Color(0xFFAA8B56),
          ),
          const SizedBox(height: 16),
          const LevelItem(
            level: 'C2',
            title: 'C2 Expert',
            description: 'Has mastered the language to a native level',
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
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
