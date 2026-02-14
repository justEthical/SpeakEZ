import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ResultTile extends StatefulWidget {
  final String icon;
  final String heading;
  final String content;
  final double padding;
  final VoidCallback? onTap;
  final double? score; // Score out of 10 for color coding
  final Animation<double>? entryAnimation;
  final bool showBorder; // Show border for non-scored tiles

  const ResultTile({
    super.key,
    this.heading = "",
    required this.content,
    required this.icon,
    this.onTap,
    this.padding = 0,
    this.score,
    this.entryAnimation,
    this.showBorder = false,
  });

  @override
  State<ResultTile> createState() => _ResultTileState();
}

class _ResultTileState extends State<ResultTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Color _getScoreColor(double? score) {
    if (score == null) {
      return Theme.of(context).colorScheme.primary;
    }
    if (score >= 7) {
      return const Color(0xFF4CAF50); // Green
    } else if (score >= 5) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFF44336); // Red
    }
  }

  Color _getScoreBorderColor(double? score) {
    if (score == null) {
      // For non-scored tiles with showBorder, use primary color
      return Theme.of(context).colorScheme.primary.withValues(alpha: 0.3);
    }
    if (score >= 7) {
      return const Color(0xFF4CAF50).withValues(alpha: 0.3);
    } else if (score >= 5) {
      return const Color(0xFFFF9800).withValues(alpha: 0.3);
    } else {
      return const Color(0xFFF44336).withValues(alpha: 0.3);
    }
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor(widget.score);
    final borderColor = _getScoreBorderColor(widget.score);

    Widget tileContent = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: () {
          HapticFeedback.mediumImpact();
          widget.onTap?.call();
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(10),
            border: (widget.score != null || widget.showBorder)
                ? Border.all(color: borderColor, width: 1.5)
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: scoreColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 5),
                          color: scoreColor.withValues(alpha: 0.5),
                          spreadRadius: 1,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(widget.padding),
                    child: SvgPicture.asset(
                      widget.icon,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onPrimary,
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.heading == ''
                          ? const SizedBox()
                          : Text(
                              widget.heading,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: widget.score != null
                                    ? scoreColor
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: Get.width - 138,
                        child: Text(
                          widget.content,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );

    // Wrap with entry animation if provided
    if (widget.entryAnimation != null) {
      return AnimatedBuilder(
        animation: widget.entryAnimation!,
        builder: (context, child) {
          return Opacity(
            opacity: widget.entryAnimation!.value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - widget.entryAnimation!.value)),
              child: child,
            ),
          );
        },
        child: tileContent,
      );
    }

    return tileContent;
  }
}
