import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Models/pronunciation_word_model.dart';
import 'package:speak_ez/Models/vocab_topic_progress.dart';
import 'package:speak_ez/Services/firestore_helper.dart';

class VocabularyTabController extends GetxController {
  var isLoadingVocabLessonNames = false.obs;
  var currentEnglishVocabLevel = EnglishVocabLevelModel.fromJson({}).obs;

  var isLoadingTopicWords = false.obs;
  var currentTopicWords = TopicWordContent.empty().obs;

  var vocabProgress = <String, VocabTopicResult>{}.obs;

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

  // ── Progress persistence ──────────────────────────────────────────────────

  String topicKey(String level, String categoryName, String topicName) {
    final cat = categoryName.replaceAll(' ', '_').replaceAll(',', '');
    final topic = topicName.replaceAll(' ', '_');
    return '${level}__${cat}__$topic';
  }

  Future<void> loadVocabProgress() async {
    // 1. Load from SharedPreferences (instant)
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(AppStrings.vocabProgressData);
      if (cached != null) {
        final map = json.decode(cached) as Map<String, dynamic>;
        vocabProgress.value = map.map(
          (key, value) => MapEntry(
            key,
            VocabTopicResult.fromMap(value as Map<String, dynamic>),
          ),
        );
      }
    } catch (e) {
      print('Error loading vocab progress from cache: $e');
    }

    // 2. Load from Firestore (background merge)
    try {
      final remote = await FirestoreHelper.fetchVocabProgress();
      if (remote != null) {
        // Merge: remote wins for keys that exist in both (server is source of truth)
        final merged = Map<String, VocabTopicResult>.from(vocabProgress);
        merged.addAll(remote);
        vocabProgress.value = merged;
        // Update cache with merged data
        _saveToCache(merged);
      }
    } catch (e) {
      print('Error loading vocab progress from Firestore: $e');
    }
  }

  Future<void> saveTopicResult(String key, VocabTopicResult result) async {
    // 1. Update in-memory (reactive)
    vocabProgress[key] = result;

    // 2. Save to SharedPreferences
    try {
      _saveToCache(vocabProgress);
    } catch (e) {
      print('Error saving vocab progress to cache: $e');
    }

    // 3. Save to Firestore (async, non-blocking)
    try {
      await FirestoreHelper.saveVocabTopicResult(key, result);
    } catch (e) {
      print('Error saving vocab progress to Firestore: $e');
    }
  }

  void _saveToCache(Map<String, VocabTopicResult> data) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(
      data.map((key, value) => MapEntry(key, value.toMap())),
    );
    prefs.setString(AppStrings.vocabProgressData, encoded);
  }

  bool isTopicCompleted(String level, String categoryName, String topicName) {
    return vocabProgress.containsKey(topicKey(level, categoryName, topicName));
  }

  VocabTopicResult? getTopicResult(
    String level,
    String categoryName,
    String topicName,
  ) {
    return vocabProgress[topicKey(level, categoryName, topicName)];
  }

  int completedTopicsInCategory(
    String level,
    String categoryName,
    List<String> topics,
  ) {
    int count = 0;
    for (final topic in topics) {
      if (isTopicCompleted(level, categoryName, topic)) count++;
    }
    return count;
  }
}
