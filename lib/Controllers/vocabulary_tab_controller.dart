import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Models/pronunciation_word_model.dart';

class VocabularyTabController extends GetxController {
  var isLoadingVocabLessonNames = false.obs;
  var currentEnglishVocabLevel = EnglishVocabLevelModel.fromJson({}).obs;

  Future<void> loadLevelData(String levelCode) async {
   
      try {
        final String response = await rootBundle.loadString(
          'assets/vocabulary_builder/topics/$levelCode.json',
        );
        final data = await json.decode(response);
        final level = EnglishVocabLevelModel.fromJson(data);
        currentEnglishVocabLevel.value = level;
      } catch (e) {
        print('Error loading JSON for $levelCode: $e');
      }
    
  }
}
