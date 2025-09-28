import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

class StreakAndWordCountSection extends StatefulWidget {
  const StreakAndWordCountSection({super.key});

  @override
  State<StreakAndWordCountSection> createState() => _StreakAndWordCountSectionState();
}

class _StreakAndWordCountSectionState extends State<StreakAndWordCountSection>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _counterController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _counterAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _counterController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _counterAnimation = CurvedAnimation(
      parent: _counterController,
      curve: Curves.easeOutBack,
    );

    _counterController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Row(
              children: [
                Obx(
                  () => _buildProgressCard(
                    context,
                    title: "Current Streak",
                    icon: AppAssets.flame,
                    progress:
                        "${globalController.userProfile.value.currentStreak} days",
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(width: 20),
                _buildProgressCard(
                  context,
                  title: "Words Learned",
                  icon: AppAssets.medal,
                  progress:
                      "${globalController.userProfile.value.wordLearned}",
                  color: Colors.deepPurple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context, {
    required String title,
    required String icon,
    required String progress,
    required Color color,
  }) {
    return Expanded(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        tween: Tween(begin: 1.0, end: 1.0),
        builder: (context, scale, child) {
          return GestureDetector(
            onTapDown: (_) => setState(() {}),
            onTapUp: (_) => setState(() {}),
            onTapCancel: () => setState(() {}),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: Matrix4.identity()..scale(scale * 0.98),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: SvgPicture.asset(
                          icon,
                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                          width: 30,
                          height: 30,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5),
                  AnimatedBuilder(
                    animation: _counterAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.5 + (_counterAnimation.value * 0.5),
                        child: Text(
                          progress,
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}