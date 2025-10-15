import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/translation_text_view.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

class VocabularyData extends StatelessWidget {
  final VocabularyItem vocabularyItem;
  const VocabularyData({super.key, required this.vocabularyItem});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                vocabularyItem.word.capitalize!,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: AppStrings.poppinsFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {                 
                  ttsHelper.speak(vocabularyItem.word);
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
            child: TranslationTextView(
              text: vocabularyItem.wordTranslation!["Hindi"].toString(),
              
            ),
          ),
          SizedBox(height: 18),
          Text(
            "Meaning:",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 17,
              fontFamily: AppStrings.poppinsFont,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            vocabularyItem.meaning,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontFamily: AppStrings.poppinsFont,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 8),
          TranslationTextView(
            text: vocabularyItem.meaningTranslation!["Hindi"].toString(),
          ),
          
          SizedBox(height: 18),
          Text(
            "Example Sentence(s)",
            style: TextStyle(
              fontSize: 17,
              fontFamily: AppStrings.poppinsFont,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(
                vocabularyItem.examples.length,
                (index) => Column(
                  children: [
                    Text(
                      "${index + 1}. ${vocabularyItem.examples[index].sentence}",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: AppStrings.poppinsFont,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8),
                    TranslationTextView(
                      text:
                          vocabularyItem.examples[index].translation!["Hindi"]
                              .toString(),
                    ),
                    SizedBox(height: 18),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
