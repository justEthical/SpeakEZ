import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Screens/Practice/Widgets/chat_bubble.dart';
import 'package:speak_ez/Screens/Practice/Widgets/chat_screen_bottom_bar.dart';

import 'Widgets/progress_bar.dart';

class ChatScreen extends StatelessWidget {
  final String title;
  const ChatScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PracticeController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      fontFamily: AppStrings.nunitoFont,
                    ),
                  ),

                  Spacer(),
                  InkWell(
                    onTap: () => c.showExitBottomSheet(context),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ProgressBar(),
              SizedBox(height: 10),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    controller: c.chatScrollController,
                    itemCount: c.currentChats.length,
                    itemBuilder: (ctx, index) {
                      return ChatBubble(chatModel: c.currentChats[index]);
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              ChatScreenBottomBar()
            ],
          ),
        ),
      ),
    );
  }
}
