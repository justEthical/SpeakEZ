import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Models/ai_response_model.dart';
import 'package:speak_ez/Models/chat_model.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

class ChatBubble extends StatelessWidget {
  final AIResponseModel? aiResponseModel;
  final ChatModel chatModel;
  const ChatBubble({super.key, required this.chatModel, this.aiResponseModel});

  @override
  Widget build(BuildContext context) {
    final PracticeController c = Get.find();
    if (chatModel.isAI) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.0),
              borderRadius: BorderRadius.circular(60),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(AppAssets.natashaChat),
            ),
          ),
          SizedBox(width: 8),

          ChatType.gettingAIResponse == chatModel.chatType
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
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.deepPurpleAccent,
                        Theme.of(context).colorScheme.primary,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        chatModel.message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 5,),
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
                                  await ttsHelper.speakAndWait(chatModel.message);
                                  c.isSpeaking = false;
                                }
                              },
                              child: Icon(Icons.volume_down),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          Spacer(),
        ],
      );
    } else {
      return Row(
        children: [
          Spacer(),

          chatModel.chatType == ChatType.transcribing
              ? SizedBox(
                width: 45,
                height: 45,
                child: Lottie.asset(
                  AppAssets.chatting,
                  decoder: globalController.customDecoder,
                ),
              )
              : (aiResponseModel == null
                  ? ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: Get.width - 120),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        gradient: const LinearGradient(
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
                        chatModel.message,
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
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.only(
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
                            chatModel.message,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                              fontSize: 15,
                            ),
                          ),
                          Divider(),
                          Text(
                            aiResponseModel!.enhancedTranscript,
                            style: TextStyle(
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
}
