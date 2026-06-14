import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/home_palette.dart';

class PracticeCardsSection extends StatelessWidget {
  const PracticeCardsSection({super.key});

  void _goToTab(int index) {
    HapticFeedback.lightImpact();
    globalController.currentTabIndex.value = index;
    globalController.cutomTabBarController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final palette = HomePalette(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --- Scenario Practice ---
          _SectionHeader(
            palette: palette,
            title: 'selectScenario'.tr,
            actionLabel: 'explore'.tr,
            onAction: () => _goToTab(1),
          ),
          const SizedBox(height: 12),
          _PracticeCard(
            palette: palette,
            icon: Icons.forum_outlined,
            accent: palette.primary,
            leftBorder: palette.primary,
            title: AppStrings.realLifeConversations.tr,
            subtitle: 'practiceRealConversations'.tr,
            onTap: () => _goToTab(1),
          ),

          const SizedBox(height: 26),

          /// --- Vocabulary Builder ---
          _SectionHeader(
            palette: palette,
            title: AppStrings.vocabularyBuilder.tr,
          ),
          const SizedBox(height: 12),
          _PracticeCard(
            palette: palette,
            icon: Icons.spellcheck_rounded,
            accent: palette.tertiary,
            title: AppStrings.vocabularyBuilder.tr,
            subtitle: AppStrings.vocabularyBuilderSubtitle.tr,
            badge: globalController.userProfile.value.currentEnglishLevel,
            onTap: () => _goToTab(2),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final HomePalette palette;
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.palette,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontFamily: AppStrings.nunitoFont,
              fontWeight: FontWeight.w800,
              color: palette.onSurface,
            ),
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(
                  actionLabel!,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: AppStrings.nunitoFont,
                    fontWeight: FontWeight.w700,
                    color: palette.primary,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.arrow_forward, size: 16, color: palette.primary),
              ],
            ),
          ),
      ],
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final HomePalette palette;
  final IconData icon;
  final Color accent;
  final String title;
  final String subtitle;
  final Color? leftBorder;
  final String? badge;
  final VoidCallback onTap;

  const _PracticeCard({
    required this.palette,
    required this.icon,
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.leftBorder,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: palette.glassCard(leftBorder: leftBorder),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: accent, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w700,
                      color: palette.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w500,
                      color: palette.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (badge != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: palette.pillColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: AppStrings.nunitoFont,
                    fontWeight: FontWeight.w600,
                    color: palette.onSurfaceVariant,
                  ),
                ),
              )
            else
              Icon(Icons.chevron_right, color: palette.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
