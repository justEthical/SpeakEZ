import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.normal),
      ),
    );
  }
}
