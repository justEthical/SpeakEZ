import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Models/ai_response_model.dart';
import 'package:speak_ez/Models/chat_model.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

class ChatBubble extends StatefulWidget {
  final AIResponseModel? aiResponseModel;
  final ChatModel chatModel;
  const ChatBubble({super.key, required this.chatModel, this.aiResponseModel});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // AI messages slide from left, user messages slide from right
    final slideBegin = widget.chatModel.isAI
        ? const Offset(-0.3, 0.1)
        : const Offset(0.3, 0.1);

    _slideAnimation = Tween<Offset>(
      begin: slideBegin,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PracticeController c = Get.find();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: widget.chatModel.isAI
                  ? Alignment.bottomLeft
                  : Alignment.bottomRight,
              child: child,
            ),
          ),
        );
      },
      child: widget.chatModel.isAI
          ? _buildAIBubble(context, c)
          : _buildUserBubble(context),
    );
  }

  Widget _buildAIBubble(BuildContext context, PracticeController c) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(60),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.asset(AppAssets.natashaChat),
          ),
        ),
        const SizedBox(width: 8),
        ChatType.gettingAIResponse == widget.chatModel.chatType
            ? SizedBox(
                width: 45,
                height: 45,
                child: Lottie.asset(
                  AppAssets.chatting,
                  decoder: globalController.customDecoder,
                ),
              )
            : ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Get.width - 120),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.deepPurpleAccent,
                        Theme.of(context).colorScheme.primary,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        widget.chatModel.message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                            child: InkWell(
                              onTap: () async {
                                if (c.isMicEnabled.value) {
                                  c.isSpeaking = true;
                                  await ttsHelper.speakAndWait(
                                    widget.chatModel.message,
                                  );
                                  c.isSpeaking = false;
                                }
                              },
                              child: const Icon(Icons.volume_down),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        const Spacer(),
      ],
    );
  }

  Widget _buildUserBubble(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        widget.chatModel.chatType == ChatType.transcribing
            ? SizedBox(
                width: 45,
                height: 45,
                child: Lottie.asset(
                  AppAssets.chatting,
                  decoder: globalController.customDecoder,
                ),
              )
            : (widget.aiResponseModel == null
                ? ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: Get.width - 120),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromARGB(255, 50, 59, 117),
                            Color.fromARGB(255, 65, 31, 234),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.chatModel.message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: Get.width - 120),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.chatModel.message,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                              fontSize: 15,
                            ),
                          ),
                          const Divider(),
                          Text(
                            widget.aiResponseModel!.enhancedTranscript,
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
      ],
    );
  }
}
