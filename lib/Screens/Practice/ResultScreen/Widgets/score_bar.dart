import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScoreBar extends StatefulWidget {
  final int score;

  const ScoreBar({
    super.key,
    required this.score,
  });

  @override
  State<ScoreBar> createState() => _ScoreBarState();
}

class _ScoreBarState extends State<ScoreBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );
    // Start shine animation after a delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _shineController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  List<Color> _getGradientColors(int score) {
    if (score >= 70) {
      return [const Color(0xFF81C784), const Color(0xFF4CAF50)];
    } else if (score >= 50) {
      return [const Color(0xFFFFCC80), const Color(0xFFFF9800)];
    } else {
      return [const Color(0xFFE57373), const Color(0xFFF44336)];
    }
  }

  Color _getGlowColor(int score) {
    if (score >= 70) {
      return const Color(0xFF4CAF50);
    } else if (score >= 50) {
      return const Color(0xFFFF9800);
    } else {
      return const Color(0xFFF44336);
    }
  }

  @override
  Widget build(BuildContext context) {
    final barWidth = Get.width - 60;
    final progressWidth = (barWidth / 100) * widget.score;

    return Stack(
      children: [
        // Background bar
        Container(
          width: barWidth,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // Progress bar with gradient and glow
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          width: progressWidth.clamp(0.0, barWidth),
          height: 12,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getGradientColors(widget.score),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: _getGlowColor(widget.score).withValues(alpha: 0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AnimatedBuilder(
              animation: _shineAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Shine effect
                    Positioned.fill(
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                            stops: [
                              _shineAnimation.value - 0.3,
                              _shineAnimation.value,
                              _shineAnimation.value + 0.3,
                            ].map((e) => e.clamp(0.0, 1.0)).toList(),
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
