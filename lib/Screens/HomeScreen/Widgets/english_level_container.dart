import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Screens/HomeScreen/list_of_lessons.dart';
import 'package:speak_ez/Utils/custom_dialogs.dart';

class EnglishLevelContainer extends StatefulWidget {
  final String level;
  final int lessons;
  final Color color;
  final bool isLocked;

  const EnglishLevelContainer({
    super.key,
    required this.level,
    required this.lessons,
    required this.color,
    this.isLocked = false,
  });

  @override
  State<EnglishLevelContainer> createState() => _EnglishLevelContainerState();
}

class _EnglishLevelContainerState extends State<EnglishLevelContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isLocked) {
      HapticFeedback.lightImpact();
      _controller.forward().then((_) {
        _controller.reverse();
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            Get.to(() => ListOfLessons(englishLevel: widget.level));
          }
        });
      });
    } else {
      HapticFeedback.mediumImpact();
      _controller.forward().then((_) {
        _controller.reverse();
      });
      showDialog(
        context: context,
        builder: (ctx) => CustomDialogs.levelIsLockedDialog(ctx, widget.level, widget.isLocked),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _handleTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double shakeOffset = 0;
          if (widget.isLocked) {
            shakeOffset = _shakeAnimation.value * 5 *
                ((_controller.value * 2 - 1).abs() - 0.5);
          }

          return Transform.translate(
            offset: Offset(shakeOffset, 0),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(
                  begin: 0.0,
                  end: _isPressed ? 8.0 : 0.0,
                ),
                builder: (context, elevation, child) {
                  return Container(
                    width: 100,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.isLocked
                            ? [
                                Colors.grey.shade400,
                                Colors.grey.shade600,
                              ]
                            : [
                                widget.color.withOpacity(0.8),
                                widget.color,
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        if (!widget.isLocked)
                          BoxShadow(
                            color: widget.color.withOpacity(0.4),
                            blurRadius: 10 + elevation,
                            offset: Offset(0, 4 + elevation / 2),
                            spreadRadius: elevation / 4,
                          ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Hero(
                                  tag: 'level-${widget.level}',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      widget.level,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontSize: 24,
                                        fontFamily: AppStrings.nunitoFont,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                                if (widget.isLocked)
                                  TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 600),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    builder: (context, value, child) {
                                      return Transform.rotate(
                                        angle: value * 0.1,
                                        child:  Icon(
                                          Icons.lock,
                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                                          size: 20,
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                            Text(
                              "${widget.lessons} Lessons",
                              style: TextStyle(
                                fontFamily: AppStrings.nunitoFont,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (!widget.isLocked && _isPressed)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}