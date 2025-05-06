import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/home_screen_controller.dart';
import 'package:speak_ez/Models/questions_model.dart';

class ListOfLessons extends StatelessWidget {
  const ListOfLessons({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeScreenController>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Lessons",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: AppStrings.nunitoFont,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    CEFRLevel.values.length,
                    (index) => InkWell(
                      onTap: () {
                        c.changeEnglishLevel(CEFRLevel.values[index].name);
                      },
                      child: Container(
                        width: 70,
                        height: 40,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color:
                              c.currenEnglishLessonLevel.value ==
                                      CEFRLevel.values[index].name
                                  ? Colors.black
                                  : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            CEFRLevel.values[index].name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: c.currentLessonNameList.length,
                  itemBuilder:
                      (ctx, i) => Container(
                        width: Get.width - 40,
                        height: 80,
                        padding: const EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepPurple,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  (i + 1).toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.currentLessonNameList[i].name,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text(c.currenEnglishLessonLevel.value),
                              ],
                            ),
                          ],
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
