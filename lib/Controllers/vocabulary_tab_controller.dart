import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Models/pronunciation_word_model.dart';

class VocabularyTabController extends GetxController {
  var isLoadingVocabLessonNames = false.obs;
  var currentEnglishVocabLevel = EnglishVocabLevelModel.fromJson({}).obs;

  var isLoadingTopicWords = false.obs;
  var currentTopicWords = TopicWordContent.empty().obs;

  Future<void> loadLevelData(String levelCode) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/vocabulary_builder/topics/$levelCode.json',
      );
      final data = json.decode(response);
      currentEnglishVocabLevel.value = EnglishVocabLevelModel.fromJson(data);
    } catch (e) {
      print('Error loading JSON for $levelCode: $e');
    }
  }

  Future<void> loadTopicWords(
    String level,
    String categoryName,
    String topicName,
  ) async {
    isLoadingTopicWords.value = true;
    try {
      final catFolder = categoryName.replaceAll(' ', '_').replaceAll(',', '');
      final topicFile = topicName.replaceAll(' ', '_');
      final path =
          'assets/vocabulary_builder/content/$level/$catFolder/$topicFile.json';
      final response = await rootBundle.loadString(path);
      final data = json.decode(response);
      currentTopicWords.value = TopicWordContent.fromJson(data);
    } catch (e) {
      print('Error loading topic words [$level/$categoryName/$topicName]: $e');
      currentTopicWords.value = TopicWordContent.empty();
    } finally {
      isLoadingTopicWords.value = false;
    }
  }
}
