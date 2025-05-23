import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Screens/Practice/Widgets/scenario_card.dart';

class PracticeSpeaking extends StatelessWidget {
  const PracticeSpeaking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Speaking Practice",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 20),
              Container(
                width: Get.width - 40,
                // height: (Get.width - 40) / 2,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(43, 143, 43, 225),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 143, 43, 225),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Icon(Icons.rocket, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: Get.width - 124,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Practice with Natasha your AI learning partner",
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Select a scenario to start practice",
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (ctx, i) {
                    return ScenarioCard(
                      title: "Job Interview",
                      subtitle: "Practice answering common interview questions with Natasha",
                      image: AppAssets.jobInterview,
                      level: "intermediate",
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
