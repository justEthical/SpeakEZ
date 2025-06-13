import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Models/scenario_model.dart';
import 'package:speak_ez/Screens/Practice/ResultScreen/practice_result_screen.dart';
import 'package:speak_ez/Screens/Practice/Widgets/chat_bubble.dart';
import 'package:speak_ez/Screens/Practice/Widgets/chat_screen_bottom_bar.dart';

import 'Widgets/progress_bar.dart';

class ChatScreen extends StatefulWidget {
  final ScenarioModel scenarioModel;
  const ChatScreen({super.key, required this.scenarioModel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final c = Get.find<PracticeController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      c.currentScenarioModel = widget.scenarioModel;
      c.addInitialMessage();
      c.startWhisperIsolate();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    c.whisperSendPort.send('stop');
    c.isWhisperInitialized.value = false;
    c.currentUserSessionMessage.value = 0;
    c.tts.stop();
    print("dissposed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    widget.scenarioModel.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      // fontFamily: AppStrings.nunitoFont,
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
              Obx(
                () =>
                    c.currentUserSessionMessage.value >= c.maxNumberOfAiResponsesPerSession
                        ? ElevatedButton(
                          onPressed: () {
                            Get.off(PracticeResultSreen(result: c.resultModel!,));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            fixedSize: Size(Get.width, 55),
                          ),
                          child: Text(
                            "View Results",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        )
                        : ChatScreenBottomBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
