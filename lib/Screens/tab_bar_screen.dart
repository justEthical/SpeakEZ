import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/recording_screen.dart';
import 'package:speak_ez/Utils/audio_recorder_helper.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  final c = Get.put(GlobalController());
  var isRecording = false.obs;
  List<int> _audioBuffer = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: globalController.cutomTabBarController,
        children: [RecordingScreen(), Container(color: Colors.green)],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Home',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          
          if (!isRecording.value) {
            _audioBuffer.clear();
            var audioBufferStream = await startRecordingAndGetStream();
            isRecording.value = true;
            audioBufferStream.listen((event) {
              _audioBuffer.addAll(event);
              print("Here");
            });
          } else {
            print(_audioBuffer.length);
            await stopRecording();
            globalController.transcribeLiveAudio(
              Uint8List.fromList(_audioBuffer),
            );
            isRecording.value = false;
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.mic, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
