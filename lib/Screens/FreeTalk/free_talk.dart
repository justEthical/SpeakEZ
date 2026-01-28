import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Constants/posthog_events.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Utils/custom_dialogs.dart';

class FreeTalk extends StatefulWidget {
  const FreeTalk({super.key});

  @override
  State<FreeTalk> createState() => _FreeTalkState();
}

class _FreeTalkState extends State<FreeTalk> with TickerProviderStateMixin {
  final c = Get.find<PracticeController>();

  late AnimationController _staggerController;
  late AnimationController _pulseController;
  late AnimationController _floatingController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    PostHogService.instance.captureScreenView('free_talk_screen');

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatingAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _pulseController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.freeTalk.tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontFamily: AppStrings.nunitoFont,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
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
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Hero Section with Lottie Animation
              _AnimatedSection(
                delay: 0,
                controller: _staggerController,
                child: _buildHeroSection(),
              ),
              const SizedBox(height: 24),
              // Feature Highlights
              _AnimatedSection(
                delay: 200,
                controller: _staggerController,
                child: _buildFeatureHighlights(),
              ),
              const SizedBox(height: 24),
              // Topic Suggestions
              _AnimatedSection(
                delay: 400,
                controller: _staggerController,
                child: _buildTopicSuggestions(),
              ),
              const SizedBox(height: 30),
              // Start Button
              _AnimatedSection(
                delay: 600,
                controller: _staggerController,
                child: _buildStartButton(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_pulseAnimation, _floatingAnimation]),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingAnimation.value),
                child: Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: Get.width * 0.4,
                    height: Get.width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Lottie.asset(
                        AppAssets.freeTalk,
                        decoder: globalController.customDecoder,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'freeTalkTitle'.tr,
            style: const TextStyle(
              fontFamily: AppStrings.nunitoFont,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.freeTalkDescription.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppStrings.nunitoFont,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureHighlights() {
    final features = [
      {
        'icon': Icons.all_inclusive_rounded,
        'title': 'freeTalkFeature1Title'.tr,
        'description': 'freeTalkFeature1Desc'.tr,
        'color': const Color(0xFF6366F1),
      },
      {
        'icon': Icons.psychology_rounded,
        'title': 'freeTalkFeature2Title'.tr,
        'description': 'freeTalkFeature2Desc'.tr,
        'color': const Color(0xFF10B981),
      },
      {
        'icon': Icons.speed_rounded,
        'title': 'freeTalkFeature3Title'.tr,
        'description': 'freeTalkFeature3Desc'.tr,
        'color': const Color(0xFFF59E0B),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'freeTalkWhyTitle'.tr,
          style: TextStyle(
            fontFamily: AppStrings.nunitoFont,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 12),
        ...features.map((feature) => _buildFeatureCard(feature)),
      ],
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (feature['color'] as Color).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (feature['color'] as Color).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (feature['color'] as Color).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: feature['color'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature['title'] as String,
                  style: TextStyle(
                    fontFamily: AppStrings.nunitoFont,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  feature['description'] as String,
                  style: TextStyle(
                    fontFamily: AppStrings.nunitoFont,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicSuggestions() {
    final topics = [
      'freeTalkTopic1'.tr,
      'freeTalkTopic2'.tr,
      'freeTalkTopic3'.tr,
      'freeTalkTopic4'.tr,
      'freeTalkTopic5'.tr,
      'freeTalkTopic6'.tr,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'freeTalkTopicsTitle'.tr,
          style: TextStyle(
            fontFamily: AppStrings.nunitoFont,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: topics.map((topic) => _buildTopicChip(topic)).toList(),
        ),
      ],
    );
  }

  Widget _buildTopicChip(String topic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        topic,
        style: TextStyle(
          fontFamily: AppStrings.nunitoFont,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return _StartFreeTalkButton(
      onPressed: () async {
        PostHogService.instance.capture(
          PostHogEvents.freeTalkStarted,
          properties: {'screen_name': 'free_talk_screen'},
        );
        final scenarioModel = c.getFreeTalkScenario();
        final status = await c.getMicrophonePermission(scenarioModel);
        if (!mounted) return;
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
    );
  }
}

class _StartFreeTalkButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _StartFreeTalkButton({required this.onPressed});

  @override
  State<_StartFreeTalkButton> createState() => _StartFreeTalkButtonState();
}

class _StartFreeTalkButtonState extends State<_StartFreeTalkButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onPressed();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mic_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                AppStrings.startFreeTalk.tr,
                style: const TextStyle(
                  fontFamily: AppStrings.nunitoFont,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
