
import 'dart:io';
import 'dart:convert';

import 'package:speak_ez/Constants/app_data.dart';

void main() async {
  await printAshFromB1Folder();
}



Future<void> printAshFromB1Folder() async {
  final directory = Directory('/Users/ash/47/SpeakEZ/assets/lessons/B1'); // folder path
  if (!await directory.exists()) {
    print("B1 folder not found.");
    return;
  }

  // List all files in the directory
  final files = directory.listSync();

  int i = 0;

  for (var file in files) {
    if (file is File && file.path.endsWith('.json')) {
      try {
        // Read file content
        final contents = await File('/Users/ash/47/SpeakEZ/assets/lessons/B1/${i+1}.json').readAsString();

        // Decode JSON
        final data = jsonDecode(contents);

        // Print "ash" value if exists
        if (data is Map && data.containsKey("lesson_name")) {
          if(data["lesson_name"] == AppData.lessonNames['B1']![i]) {
            print('true');
          }else{
            print(data["lesson_name"]);
            print("$i :: ${AppData.lessonNames['B1']![i]}");  
          }
        } else {
          print('From ${file.path}: No "ash" key found.');
        }
      } catch (e) {
        print('Error reading ${file.path}: $e');
      }
    }
    i++;
  }
}
