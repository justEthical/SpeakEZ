import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Constants/posthog_events.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Models/scenario_model.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Utils/custom_dialogs.dart';

import 'scenarios_list.dart';

class PracticeSpeaking extends StatefulWidget {
  const PracticeSpeaking({super.key});

  @override
  State<PracticeSpeaking> createState() => _PracticeSpeakingState();
}

class _PracticeSpeakingState extends State<PracticeSpeaking>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    PostHogService.instance.captureScreenView('practice_speaking_screen');
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _staggerController,
              curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
            ),
          ),
          child: Text(
            AppStrings.speakingPractice.tr,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontFamily: AppStrings.nunitoFont,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _staggerController,
                  curve: const Interval(0.1, 0.4, curve: Curves.elasticOut),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 24,
                    child: Image.asset(AppAssets.gem),
                  ),
                  const SizedBox(width: 4),
                  Obx(
                    () => Text(
                      globalController.userProfile.value.gems.toString(),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AnimatedHeader(controller: _staggerController),
            Expanded(
              child: _AnimatedScenarioGrid(controller: _staggerController),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedScenarioGrid extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedScenarioGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.95,
        ),
        itemCount: AppData.scenarioCategories.length,
        itemBuilder: (context, index) {
          final delay = 0.2 + (index * 0.08);
          final endDelay = (delay + 0.4).clamp(0.0, 1.0);

          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: Interval(
                    delay.clamp(0.0, 1.0),
                    endDelay,
                    curve: Curves.easeOutBack,
                  ),
                ),
              );

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _ScenarioCategoryCard(
              category: AppData.scenarioCategories[index],
              index: index,
            ),
          );
        },
      ),
    );
  }
}

class _ScenarioCategoryCard extends StatefulWidget {
  final ScenarioCategoryModel category;
  final int index;

  const _ScenarioCategoryCard({required this.category, required this.index});

  @override
  State<_ScenarioCategoryCard> createState() => _ScenarioCategoryCardState();
}

class _ScenarioCategoryCardState extends State<_ScenarioCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  // Gradient colors for each category
  static const List<List<Color>> _gradients = [
    [Color(0xFF667eea), Color(0xFF764ba2)], // Purple
    [Color(0xFFf093fb), Color(0xFFf5576c)], // Pink
    [Color(0xFF4facfe), Color(0xFF00f2fe)], // Blue
    [Color(0xFF43e97b), Color(0xFF38f9d7)], // Green
    [Color(0xFFfa709a), Color(0xFFfee140)], // Orange-Pink
    [Color(0xFF30cfd0), Color(0xFF330867)], // Cyan-Purple
    [Color(0xFFa8edea), Color(0xFFfed6e3)], // Mint-Pink
    [Color(0xFFffecd2), Color(0xFFfcb69f)], // Peach
  ];

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  void _onTap() {
    HapticFeedback.lightImpact();
    Get.to(
      () => ScenariosList(scenarioModel: widget.category),
      transition: Transition.cupertino,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _gradients[widget.index % _gradients.length];

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: _onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Positioned(
                left: -15,
                bottom: -15,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Hero(
                          tag: widget.category.title,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Image.asset(
                              widget.category.assetPath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.category.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'practice'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontFamily: AppStrings.nunitoFont,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedHeader extends StatefulWidget {
  final AnimationController controller;

  const _AnimatedHeader({required this.controller});

  @override
  State<_AnimatedHeader> createState() => _AnimatedHeaderState();
}

class _AnimatedHeaderState extends State<_AnimatedHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.controller,
            curve: const Interval(0.1, 0.5, curve: Curves.easeOutCubic),
          ),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.3),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
        child: GestureDetector(
          onTap: () async {
            HapticFeedback.lightImpact();
            PostHogService.instance.capture(
              PostHogEvents.freeTalkStarted,
              properties: {'screen_name': 'practice_speaking_screen'},
            );
            final practiceController = Get.find<PracticeController>();
            final scenarioModel = practiceController.getFreeTalkScenario();
            final status = await practiceController.getMicrophonePermission(
              scenarioModel,
            );

            if (!context.mounted) return;
            if (status) {
              showDialog(
                context: context,
                builder: (ctx) {
                  return CustomDialogs.startPracticeDialog(
                    context,
                    scenarioModel,
                  );
                },
              );
            }
          },
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final scale = 1.0 + (_pulseController.value * 0.1);
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          AppAssets.natashaChat,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'freeTalkTitle'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          fontFamily: AppStrings.nunitoFont,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'talkAboutAnything'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          fontFamily: AppStrings.nunitoFont,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'practice'.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontFamily: AppStrings.nunitoFont,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // const SizedBox(width: 8),
                // const Icon(
                //   Icons.arrow_forward_rounded,
                //   color: Colors.white,
                //   size: 20,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DownloadingState extends StatelessWidget {
  const DownloadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              AppAssets.downloading,
              width: Get.width * 0.4,
              height: Get.width * 0.4,
              decoder: globalController.customDecoder,
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.downloadingNatashaAI.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 20,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Text(
                "${AppStrings.downloadInfo.tr} (${globalController.aiModelDownloadProgress.value.toStringAsFixed(0)}%)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppStrings.nunitoFont,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: globalController.aiModelDownloadProgress.value / 100,
                    backgroundColor: Colors.grey.shade300,
                    minHeight: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
