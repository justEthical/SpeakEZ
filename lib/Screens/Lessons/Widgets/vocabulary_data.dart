import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Models/lesson_model_new.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

class VocabularyData extends StatelessWidget {
  final VocabularyItem  vocabularyItem;
  const VocabularyData({super.key, required this.vocabularyItem});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                vocabularyItem.word,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  final tts = TextToSpeechService();
                  tts.speak(vocabularyItem.word);
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black,
                  ),
                  child: SvgPicture.asset(AppAssets.speak, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Center(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey, width: 0.4),
                color: Colors.grey[200],
              ),
              child: Text(
                vocabularyItem.wordTranslation!["Hindi"]
                    .toString(),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          SizedBox(height: 18),
          Text(
            "Meaning:",
            style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            vocabularyItem.meaning,
            textAlign: TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey, width: 0.4),
              color: Colors.grey[200],
            ),
            child: Text(
              vocabularyItem.meaningTranslation!["Hindi"]
                  .toString(),
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
