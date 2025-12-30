import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Models/scenario_model.dart';
import 'package:speak_ez/Utils/custom_dialogs.dart';

class ScenarioCard extends StatelessWidget {
  final ScenarioModel scenarioModel;

  const ScenarioCard({super.key, required this.scenarioModel});

  @override
  Widget build(BuildContext context) {
    final PracticeController c = Get.find<PracticeController>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(scenarioModel.imagePath),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scenarioModel.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      scenarioModel.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: AppStrings.nunitoFont,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async{
              final status = await c.getMicrophonePermission(scenarioModel);
              if(status){
                showDialog(
                context: context,
                builder: (ctx) {
                  return CustomDialogs.startPracticeDialog(
                    context,
                    scenarioModel,

                  );
                },
              );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              textStyle: TextStyle(
                fontSize: 16,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w800,
              ),
            ),
            child: Text(AppStrings.startPractice.tr),
          ),
        ],
      ),
    );
  }
}
