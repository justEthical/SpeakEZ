import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircularScoreIndicator extends StatelessWidget {
  final int score;
  final double size;
  final Animation<double> animation;
  final Animation<double>? countAnimation;

  const CircularScoreIndicator({
    super.key,
    required this.score,
    required this.animation,
    this.countAnimation,
    this.size = 160,
  });

  Color _getScoreColor(int score) {
    if (score >= 70) {
      return const Color(0xFF4CAF50); // Green
    } else if (score >= 50) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFF44336); // Red
    }
  }

  List<Color> _getGradientColors(int score) {
    if (score >= 70) {
      return [const Color(0xFF81C784), const Color(0xFF4CAF50), const Color(0xFF2E7D32)];
    } else if (score >= 50) {
      return [const Color(0xFFFFCC80), const Color(0xFFFF9800), const Color(0xFFE65100)];
    } else {
      return [const Color(0xFFE57373), const Color(0xFFF44336), const Color(0xFFB71C1C)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final animatedScore = (score * animation.value).round();
        final displayScore = countAnimation != null
            ? (score * countAnimation!.value).round()
            : animatedScore;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect
              CustomPaint(
                size: Size(size, size),
                painter: _GlowPainter(
                  progress: animation.value * score / 100,
                  color: _getScoreColor(score),
                ),
              ),
              // Main arc
              CustomPaint(
                size: Size(size, size),
                painter: _CircularProgressPainter(
                  progress: animation.value * score / 100,
                  gradientColors: _getGradientColors(score),
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  strokeWidth: 12,
                ),
              ),
              // Score text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$displayScore',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  Text(
                    '/100',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.gradientColors,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    // Background arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Gradient arc
    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: gradientColors,
        stops: const [0.0, 0.5, 1.0],
        transform: const GradientRotation(-math.pi / 2),
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _GlowPainter extends CustomPainter {
  final double progress;
  final Color color;

  _GlowPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 12) / 2;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
