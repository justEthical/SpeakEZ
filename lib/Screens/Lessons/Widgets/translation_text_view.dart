import 'package:flutter/material.dart';
import 'package:speak_ez/Constants/app_strings.dart';

class TranslationTextView extends StatelessWidget {
  final String text;
  const TranslationTextView({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 0.4),
        color: Theme.of(context).colorScheme.primary.withValues(alpha:  0.1)   ,
      ),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 14, fontFamily: AppStrings.poppinsFont, fontWeight: FontWeight.normal),
      ),
    );
  }
}
