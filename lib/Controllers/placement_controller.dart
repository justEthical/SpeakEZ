import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/placement_model.dart';

/// Drives the onboarding placement test (Learna-style "select the words you
/// know" pills). The word-pills are the ONLY objective signal that sets the
/// user's CEFR level, replacing the previously hard-coded A1.
class PlacementController extends GetxController {
  static const String _assetPath = 'assets/placement/word_bank.json';

  final pageController = PageController(initialPage: 0);
  final currentBandIndex = 0.obs;
  final isLoading = true.obs;
  final hasError = false.obs;

  // Words the user tapped as "known" (real words + pseudowords), keyed by the
  // word string. Pseudowords are unique invented strings, so no collisions.
  final selected = <String>{}.obs;

  PlacementWordBank? bank;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      final raw = await rootBundle.loadString(_assetPath);
      bank = PlacementWordBank.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      if (bank!.bands.isEmpty) hasError.value = true;
    } catch (e) {
      debugPrint('[Placement] failed to load word bank: $e');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  bool isSelected(String word) => selected.contains(word);

  void toggle(String word) {
    if (selected.contains(word)) {
      selected.remove(word);
    } else {
      selected.add(word);
    }
  }

  bool get isLastBand =>
      bank == null || currentBandIndex.value >= bank!.bands.length - 1;

  void nextBand() {
    if (bank == null) return;
    if (currentBandIndex.value < bank!.bands.length - 1) {
      currentBandIndex.value++;
      pageController.animateToPage(
        currentBandIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void previousBand() {
    if (currentBandIndex.value > 0) {
      currentBandIndex.value--;
      pageController.animateToPage(
        currentBandIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  /// Adjusted known-rate for a band: (known real words / total real words)
  /// minus the pseudoword penalty (fraction of fake words tapped as known).
  /// Clamped to [0, 1].
  double _adjustedRate(PlacementBand band) {
    if (band.words.isEmpty) return 0;
    final known = band.words.where(selected.contains).length;
    final rate = known / band.words.length;
    final penalty = band.pseudowords.isEmpty
        ? 0.0
        : band.pseudowords.where(selected.contains).length /
            band.pseudowords.length;
    return (rate - penalty).clamp(0.0, 1.0);
  }

  /// Maps the 3 band scores to a CEFR level. Monotonic ladder: each higher pair
  /// is gated behind knowing the lower pair well (upper threshold), so a
  /// beginner can never skip to B2. `lower`/`upper` split each pair into
  /// below / lower-band / upper-band.
  String computeLevel() {
    final levels = AppData.englishLevel; // [A1, A2, B1, B2, C1, C2]
    if (bank == null || bank!.bands.length < 3) return levels.first;

    final adjA = _adjustedRate(bank!.bands[0]); // A1-A2
    final adjB = _adjustedRate(bank!.bands[1]); // B1-B2
    final adjC = _adjustedRate(bank!.bands[2]); // C1-C2

    const lower = 0.34;
    const upper = 0.67;

    var idx = 0; // A1
    if (adjA >= upper) idx = 1; // A2
    if (adjA >= upper && adjB >= lower) idx = 2; // B1
    if (adjA >= upper && adjB >= upper) idx = 3; // B2
    if (adjA >= upper && adjB >= upper && adjC >= lower) idx = 4; // C1
    if (adjA >= upper && adjB >= upper && adjC >= upper) idx = 5; // C2

    // Self-report tie-break: a not-confident user placed above A2 gets nudged
    // down one band (word recognition can outrun speaking confidence).
    final confidence = globalController.userProfile.value.confidence;
    if (confidence == 'Not confident at all' && idx > 1) idx -= 1;

    return levels[idx.clamp(0, levels.length - 1)];
  }

  /// Persists the placed level onto the profile, overriding the hard-coded A1
  /// set at signup. Writes to SharedPreferences + Firestore via updateProfile.
  void persistLevel(String level) {
    globalController.userProfile.value.currentEnglishLevel = level;
    globalController.userProfile.value.currentEnglishLevelProgress = 0;
    globalController.userProfile.refresh();
    globalController.updateProfile();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
