import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/placement_controller.dart';
import 'package:speak_ez/Models/placement_model.dart';
import 'package:speak_ez/Screens/OnBoarding/Placement/placement_result_screen.dart';
import 'package:speak_ez/Screens/OnBoarding/preparing_screen.dart';

class PlacementWordsScreen extends StatelessWidget {
  const PlacementWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PlacementController>();
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).textTheme.bodyLarge?.color),
          onPressed: () {
            if (c.currentBandIndex.value == 0) {
              Get.back();
            } else {
              c.previousBand();
            }
          },
        ),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          // If the bank can't load, don't trap the user — default to A1.
          if (c.hasError.value || c.bank == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              c.persistLevel('A1');
              Get.offAll(() => const PreparingScreen());
            });
            return const Center(child: CircularProgressIndicator());
          }

          final bands = c.bank!.bands;
          return Column(
            children: [
              // Progress across the 3 bands.
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (c.currentBandIndex.value + 1) / bands.length,
                    minHeight: 6,
                    backgroundColor: primary.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(primary),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: c.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bands.length,
                  itemBuilder: (context, i) => _BandPage(band: bands[i]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _onContinue(c),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      c.isLastBand ? 'See my level' : 'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _onContinue(PlacementController c) {
    if (c.isLastBand) {
      final level = c.computeLevel();
      c.persistLevel(level);
      Get.off(() => PlacementResultScreen(level: level));
    } else {
      c.nextBand();
    }
  }
}

class _BandPage extends StatelessWidget {
  final PlacementBand band;
  const _BandPage({required this.band});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PlacementController>();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Select all the words you know',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontFamily: AppStrings.nunitoFont,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            band.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontFamily: AppStrings.nunitoFont,
              fontWeight: FontWeight.w600,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: band.displayWords
                  .map((w) => _WordChip(
                        word: w,
                        selected: c.isSelected(w),
                        onTap: () => c.toggle(w),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _WordChip extends StatelessWidget {
  final String word;
  final bool selected;
  final VoidCallback onTap;
  const _WordChip({
    required this.word,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final baseColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? primary : baseColor.withValues(alpha: 0.25),
            width: selected ? 2 : 1.2,
          ),
        ),
        child: Text(
          word,
          style: TextStyle(
            fontSize: 16,
            fontFamily: AppStrings.nunitoFont,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? primary : baseColor,
          ),
        ),
      ),
    );
  }
}
