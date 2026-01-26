import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/streak_screen.dart';
import 'package:speak_ez/Screens/SettingsScreen/Widgets/reauthentication_bottom_sheet.dart';
import 'package:speak_ez/Screens/SettingsScreen/Widgets/select_language.dart';
import 'package:speak_ez/Utils/common_widgets.dart';
import 'package:speak_ez/Utils/custom_dialogs.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';

class SettingScreens extends StatefulWidget {
  const SettingScreens({super.key});

  @override
  State<SettingScreens> createState() => _SettingScreensState();
}

class _SettingScreensState extends State<SettingScreens>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    PostHogService.instance.captureScreenView('settings_screen');
    PostHogService.instance.capture(PostHogEvents.settingsOpened);

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(context),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Stats Section
                  _AnimatedSection(
                    delay: 0,
                    controller: _staggerController,
                    child: _buildStatsSection(context),
                  ),

                  const SizedBox(height: 24),

                  // App Settings Section
                  _AnimatedSection(
                    delay: 150,
                    controller: _staggerController,
                    child: _buildSettingsSection(
                      context,
                      title: 'settingsAppSection'.tr,
                      items: [
                        _SettingsItem(
                          icon: Icons.language_rounded,
                          color: const Color(0xFF6366F1),
                          title: 'settingsLanguage'.tr,
                          subtitle: _getLanguage(
                            globalController.userProfile.value.appLanguage,
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              showDragHandle: true,
                              isScrollControlled: true,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              builder: (ctx) => SelectLanguageBottomSheet(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Support Section
                  _AnimatedSection(
                    delay: 300,
                    controller: _staggerController,
                    child: _buildSettingsSection(
                      context,
                      title: 'settingsSupportSection'.tr,
                      items: [
                        _SettingsItem(
                          icon: Icons.help_outline_rounded,
                          color: const Color(0xFF10B981),
                          title: AppStrings.help.tr,
                          subtitle: AppStrings.privacyPolicy.tr,
                          onTap: () {
                            _trackAndExecute(AppStrings.help.tr, () {
                              globalController.openUrl(
                                AppStrings.privacyPolicyUrl.tr,
                              );
                            });
                          },
                        ),
                        _SettingsItem(
                          icon: Icons.star_rounded,
                          color: const Color(0xFFF59E0B),
                          title: AppStrings.rateUs.tr,
                          subtitle: AppStrings.rateUsOnGooglePlay.tr,
                          onTap: () {
                            _trackAndExecute(AppStrings.rateUs.tr, () {
                              globalController.openUrl(AppStrings.appPlayStoreUrl);
                            });
                          },
                        ),
                        _SettingsItem(
                          icon: Icons.card_giftcard_rounded,
                          color: const Color(0xFFEC4899),
                          title: AppStrings.referToFriend.tr,
                          subtitle: AppStrings.shareWithFriends.tr,
                          onTap: () async {
                            _trackAndExecute(AppStrings.referToFriend.tr, () async {
                              await SharePlus.instance.share(
                                ShareParams(
                                  text:
                                      '${AppStrings.appShareMessage}\n${AppStrings.appPlayStoreUrl}',
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Account Section
                  _AnimatedSection(
                    delay: 450,
                    controller: _staggerController,
                    child: _buildSettingsSection(
                      context,
                      title: 'settingsAccountSection'.tr,
                      items: [
                        _SettingsItem(
                          icon: Icons.logout_rounded,
                          color: const Color(0xFF8B5CF6),
                          title: AppStrings.logout.tr,
                          subtitle: 'settingsLogoutSubtitle'.tr,
                          onTap: () {
                            _trackAndExecute(AppStrings.logout.tr, () {
                              Get.defaultDialog(
                                titleStyle: const TextStyle(fontSize: 0),
                                content: CustomDialogs.logoutDialog(Get.context!),
                              );
                            });
                          },
                        ),
                        _SettingsItem(
                          icon: Icons.delete_outline_rounded,
                          color: const Color(0xFFEF4444),
                          title: AppStrings.deleteAccount.tr,
                          subtitle: AppStrings.deleteAccountAndData.tr,
                          isDanger: true,
                          onTap: () {
                            _trackAndExecute(AppStrings.deleteAccount.tr, () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                builder: (ctx) {
                                  return ReauthenticationBottomSheet();
                                },
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // App Version
                  _AnimatedSection(
                    delay: 600,
                    controller: _staggerController,
                    child: Center(
                      child: Obx(
                        () => Text(
                          globalController.appVersion.value,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppStrings.nunitoFont,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            children: [
              // Header Row
              Row(
                children: [
                  Text(
                    AppStrings.settings.tr,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontFamily: AppStrings.nunitoFont,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: Image.asset(AppAssets.gem),
                        ),
                        const SizedBox(width: 6),
                        Obx(
                          () => Text(
                            globalController.userProfile.value.gems.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontFamily: AppStrings.nunitoFont,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Profile Info
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: UrlImage(url: _getImageUrl()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            globalController.userProfile.value.displayName,
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w800,
                              fontFamily: AppStrings.nunitoFont,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(
                          () => Text(
                            globalController.userProfile.value.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                              fontFamily: AppStrings.nunitoFont,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Obx(
                            () => Text(
                              '${'settingsLevel'.tr}: ${globalController.userProfile.value.currentEnglishLevel}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppStrings.nunitoFont,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          _buildStatCard(
            context,
            icon: Icons.local_fire_department_rounded,
            value: '${globalController.userProfile.value.currentStreak}',
            label: AppStrings.days.tr,
            color: Colors.deepOrange,
            onTap: () => Get.to(() => StreakScreen()),
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            context,
            icon: Icons.menu_book_rounded,
            value: '${globalController.userProfile.value.wordLearned}',
            label: 'settingsWords'.tr,
            color: const Color(0xFF6366F1),
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            context,
            icon: Icons.diamond_rounded,
            value: '${globalController.userProfile.value.gems}',
            label: AppStrings.gems.tr,
            color: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            HapticFeedback.lightImpact();
            onTap();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppStrings.nunitoFont,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppStrings.nunitoFont,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<_SettingsItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: AppStrings.nunitoFont,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.5),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;
              return _buildSettingsTile(context, item, showDivider: !isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    _SettingsItem item, {
    bool showDivider = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          item.onTap();
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item.icon,
                      color: item.color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppStrings.nunitoFont,
                            color: item.isDanger
                                ? item.color
                                : Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                        if (item.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppStrings.nunitoFont,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.3),
                    size: 24,
                  ),
                ],
              ),
              if (showDivider)
                Padding(
                  padding: const EdgeInsets.only(top: 14, left: 58),
                  child: Divider(
                    height: 1,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.1),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _trackAndExecute(String optionName, VoidCallback action) {
    PostHogService.instance.capture(
      PostHogEvents.settingsOptionClicked,
      properties: {
        'option_name': optionName,
      },
    );
    action();
  }

  String _getImageUrl() {
    if (globalController.userProfile.value.photoUrl == '' ||
        globalController.userProfile.value.photoUrl == null) {
      return 'https://avatar.iran.liara.run/public';
    } else {
      return globalController.userProfile.value.photoUrl!;
    }
  }

  String _getLanguage(String langCode) {
    for (var lang in AppData.appLanguages) {
      if (lang.code == langCode) {
        return lang.language;
      }
    }
    return "English";
  }
}

class _SettingsItem {
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDanger;

  _SettingsItem({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });
}

class _AnimatedSection extends StatelessWidget {
  final int delay;
  final AnimationController controller;
  final Widget child;

  const _AnimatedSection({
    required this.delay,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              delay / 1200,
              (delay + 600) / 1200,
              curve: Curves.easeOutCubic,
            ),
          ),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(animation),
            child: child!,
          ),
        );
      },
      child: child,
    );
  }
}
