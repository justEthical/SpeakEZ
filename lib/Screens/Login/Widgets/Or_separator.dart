import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:speak_ez/Constants/app_strings.dart';

class OrSeparator extends StatelessWidget {
  const OrSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20)),
          child:  Center(
            child: Text(
              AppStrings.or.tr,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
        )
      ],
    );
  }
}
