import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/vocabulary_tab_controller.dart';
import 'package:speak_ez/Screens/VocabularyTab/Pronunciation/category_screen.dart';
import 'package:speak_ez/Services/posthog_service.dart';

class PronunciationIntroScreen extends StatefulWidget {
  const PronunciationIntroScreen({super.key});

  @override
  State<PronunciationIntroScreen> createState() =>
      _PronunciationIntroScreenState();
}

class _PronunciationIntroScreenState extends State<PronunciationIntroScreen> {
  final c = Get.put(VocabularyTabController());

  int _selectedIndex = 0;
  static const List<Color> _selectedGradient = [
    Color(0xFF0EA5E9),
    Color(0xFF2563EB),
  ];

  @override
  Widget build(BuildContext context) {
    PostHogService.instance.captureScreenView('pronunciation_intro_screen');
    final colorScheme = Theme.of(context).colorScheme;
    final ink = colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ink,
          ),
        ),
        title: Text(
          AppStrings.pronunciationPractice.tr,
          style: TextStyle(
            color: ink,
            fontFamily: AppStrings.nunitoFont,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -90,
              right: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF22D3EE).withValues(alpha: 0.18),
                ),
              ),
            ),
            Positioned(
              top: 160,
              left: -90,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0EA5E9), Color(0xFF1D4ED8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0EA5E9).withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.vocabPickEra.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: AppStrings.nunitoFont,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.vocabPickEraSubtitle.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: AppStrings.nunitoFont,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: GridView.builder(
                      itemCount: AppData.englishVobularyLevels.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.88,
                          ),
                      itemBuilder: (context, index) {
                        final entry = AppData.englishVobularyLevels.entries.toList()[index];
                        final isSelected = _selectedIndex == index;
                        return _LevelTile(
                          title: entry.value['title'] as String,
                          subtitle: entry.value['subtitle'] as String,
                          isSelected: isSelected,
                          index: index,
                          onTap: () => setState(() => _selectedIndex = index),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(colors: _selectedGradient),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.to(CategoryScreen(levelCode: AppData.englishVobularyLevels.keys.toList()[_selectedIndex],));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          fixedSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'startNow'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: AppStrings.nunitoFont,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  const _LevelTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.index,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = colorScheme.onSecondary;
    final ink = colorScheme.onSurface;
    final unselectedBorder = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : const Color(0xFFE5E7EB);
    final subtleText = isDark
        ? Colors.white.withValues(alpha: 0.45)
        : const Color(0xFF6B7280);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: cardBg,
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : unselectedBorder,
              width: isSelected ? 2.4 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xFF2563EB).withValues(alpha: 0.20)
                    : Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                blurRadius: isSelected ? 16 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              SvgPicture.asset(
                AppAssets.levelIcon(index),
                width: 36,
                height: 36,
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF1D4ED8)
                      : ink,
                  fontFamily: AppStrings.nunitoFont,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF2563EB).withValues(alpha: 0.8)
                      : subtleText,
                  fontFamily: AppStrings.nunitoFont,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    isSelected
                        ? AppStrings.vocabSelected.tr
                        : AppStrings.vocabTapToSelect.tr,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF1D4ED8)
                          : subtleText,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.arrow_forward_rounded,
                    size: 18,
                    color: isSelected
                        ? const Color(0xFF1D4ED8)
                        : subtleText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
