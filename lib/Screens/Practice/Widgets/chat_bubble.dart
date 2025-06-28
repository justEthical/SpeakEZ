import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/chat_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatModel chatModel;
  const ChatBubble({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    if (chatModel.isAI) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 45,
            height: 45,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(AppAssets.natashaChat),
            ),
          ),
          SizedBox(width: 10),

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
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.deepPurpleAccent, Colors.deepPurple],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    chatModel.message,
                    style: TextStyle(color: Colors.white, fontSize: 15),
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

          chatModel.chatType == ChatType.transcribing ? SizedBox(
            width: 45,
            height: 45,
            child: Lottie.asset(
              AppAssets.chatting,
              decoder: globalController.customDecoder,
            ),
          ) : ConstrainedBox(
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
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          )
        ],
      );
    }
  }
}
