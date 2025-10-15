import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Screens/Practice/Widgets/chat_bubble.dart';

class DetailedResult extends StatelessWidget {
  const DetailedResult({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PracticeController>();
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).textTheme.bodyMedium?.color ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Detailed Feedback",
          style: TextStyle(
            fontSize: 22,
            fontFamily: AppStrings.nunitoFont,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).textTheme.bodyMedium?.color    ,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: c.chatScrollController,
                itemCount: c.currentChats.length,
                itemBuilder: (ctx, index) {
                  final aiResponseIndex = (((index + 1) / 2).toInt() - 1).abs();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ChatBubble(
                      chatModel: c.currentChats[index],
                      aiResponseModel: c.aiResponseList[aiResponseIndex],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(Get.width, 50),
              ),
              child: Text(
                "Done",
                style: TextStyle(
                  fontFamily: AppStrings.nunitoFont,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
