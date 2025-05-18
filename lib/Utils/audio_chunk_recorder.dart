import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Utils/whisper_helper.dart';

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
    final c = Get.find<PracticeController>();
    final dir = await getApplicationDocumentsDirectory();
    _shouldStop = false; // reset flag

    if (await _recorder.hasPermission()) {
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

          print('🔊 Amplitude: $level at ${duration}s');

          if (duration >= 10 && level < -13.0) {
            print('⏸️ Silence detected, stopping chunk...');
            recording = false;

            await _recorder.stop();
            isolateTranscriptionWork(path);
            break;
          }
        }

        // Optional: short pause before starting next recording
        await Future.delayed(Duration(milliseconds: 500));
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
    }
    // await transcribeLastRecordingChunk();
  }

  isolateTranscriptionWork(String filePath) async {
    final ReceivePort port = ReceivePort();
    final token = RootIsolateToken.instance!;
    await Isolate.spawn(WhisperHelper.transcribe, [
      filePath,
      globalController.appDocDirectoryPath,
      token,
      port.sendPort,
    ]);

    final result = await port.first;
    port.close();
    Get.find<PracticeController>().transcriptionText.value += result;
  }

  Future<void> transcribeLastRecordingChunk() async {
    final dir = await getApplicationDocumentsDirectory();
    final lastRecordingChunkPath = '${dir.path}/$_fileIndex.wav';

    if (await File(lastRecordingChunkPath).exists()) {
      await _recorder.stop();
      isolateTranscriptionWork(lastRecordingChunkPath);
    }
  }
}
