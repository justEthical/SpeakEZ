import 'dart:io';
import 'dart:isolate';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';

class AudioChunkRecorder {
  final _recorder = AudioRecorder();
  int _fileIndex = 0;
  bool recording = false;
  bool _shouldStop = false;

  final config = RecordConfig(
    encoder: AudioEncoder.wav,
    sampleRate: 16000,
    bitRate: 128000,
  );

  Future<void> startAutoRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    _shouldStop = false; // reset flag
    Get.find<PracticeController>().transcriptionText.value = "";
    Get.find<PracticeController>().isLastChunkTranscribed.value = false;
    try {
      await _recorder.stop();
      print("Reached permission check"); // <-- add this
      final hasPermission = await _recorder.hasPermission();
      print(hasPermission);
    } catch (e) {
      print(e.toString());
    }
    final hasPermission = await _recorder.hasPermission();
    print(hasPermission);
    if (hasPermission) {
      while (!_shouldStop) {
        final path = '${dir.path}/${_fileIndex++}.wav';
        print('🎙️ Recording: $path');

        await _recorder.start(config, path: path);

        final start = DateTime.now();
        recording = true;

        while (recording && !_shouldStop) {
          await Future.delayed(Duration(milliseconds: 500));

          final duration = DateTime.now().difference(start).inSeconds;
          final amplitude = await _recorder.getAmplitude();
          final double level = amplitude.current;

          // print('🔊 Amplitude: $level at ${duration}s');

          if (duration >= 5 && level < -13.0) {
            print('⏸️ Silence detected, stopping chunk...');
            recording = false;

            await _recorder.stop();
            transcribeWithPersistentIsolate(path);
            break;
          }
        }
      }

      print('🛑 Recording fully stopped');
    } else {
      print('Permission not granted');
    }
  }

  Future<void> stop() async {
    _shouldStop = true;
    recording = false;
    if (await _recorder.isRecording()) {
      await _recorder.stop();
      await _recorder.dispose();
    }
    final dir = await getApplicationDocumentsDirectory();
    final lastRecordingChunkPath = '${dir.path}/${_fileIndex - 1}.wav';
    print("heerree");
    await transcribeWithPersistentIsolate(lastRecordingChunkPath);
    try {
      Get.find<PracticeController>().isLastChunkTranscribed.value = true;
    } catch (e) {
      print(e.toString());
    }
    print("last recording transcribed");
  }

  Future<void> transcribeWithPersistentIsolate(String filePath) async {
    if (File(filePath).existsSync()) {
      print('file exists');
      final c = Get.find<PracticeController>();
      final ReceivePort responsePort = ReceivePort();

      c.whisperSendPort.send({
        'file': filePath,
        'replyTo': responsePort.sendPort,
      });

      final result = await responsePort.first;
      print('TRANSCRIBED: $result');
      c.transcriptionText.value += result;
    }
  }
}
