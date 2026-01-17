import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Services/network_service.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';

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

  Future<void> startAutoRecording({bool isFromLesson = false}) async {
    final dir = await getApplicationDocumentsDirectory();
    _shouldStop = false; // reset flag

    globalController.transcriptionText.value = "";
    globalController.isLastChunkTranscribed.value = false;

    try {
      await _recorder.stop();
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.audioError,
        errorMessage: e.toString(),
        location: 'AudioChunkRecorder.startWhisperRecording',
      );
      debugPrint(e.toString());
    }
    final hasPermission = await _recorder.hasPermission();
    if (hasPermission) {
      while (!_shouldStop) {
        final path = '${dir.path}/${_fileIndex++}.wav';
        debugPrint('🎙️ Recording: $path');

        await _recorder.start(config, path: path);

        final start = DateTime.now();
        recording = true;

        while (recording && !_shouldStop) {
          await Future.delayed(Duration(milliseconds: 500));

          final duration = DateTime.now().difference(start).inSeconds;
          final amplitude = await _recorder.getAmplitude();
          final double level = amplitude.current;

          // debugPrint('🔊 Amplitude: $level at ${duration}s');

          if (duration >= 5 && level < -13.0) {
            debugPrint('⏸️ Silence detected, stopping chunk...');
            recording = false;

            await _recorder.stop();
            transcribeWithPersistentIsolate(path, isFromLesson);
            break;
          }
        }
      }

      debugPrint('🛑 Recording fully stopped');
    } else {
      debugPrint('Permission not granted');
    }
  }

  Future<void> stop({bool isFromLesson = false}) async {
    _shouldStop = true;
    recording = false;
    if (await _recorder.isRecording()) {
      await _recorder.stop();
      await _recorder.dispose();
    }
    final dir = await getApplicationDocumentsDirectory();
    final lastRecordingChunkPath = '${dir.path}/${_fileIndex - 1}.wav';
    debugPrint("heerree");
    await transcribeWithPersistentIsolate(lastRecordingChunkPath, isFromLesson);
    globalController.isLastChunkTranscribed.value = true;
    debugPrint("last recording transcribed");
  }

  Future<void> transcribeWithPersistentIsolate(
    String filePath,
    bool isFromLesson,
  ) async {
    if (File(filePath).existsSync()) {
      debugPrint('file exists');
      
      final ReceivePort responsePort = ReceivePort();

      globalController.whisperSendPort?.send({
        'file': filePath,
        'replyTo': responsePort.sendPort,
      });

      final result = await responsePort.first;
      debugPrint('TRANSCRIBED: $result');
      globalController.transcriptionText.value += result;
    }
  }

  Future<void> startRecording() async{
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/recording.wav';
    _recorder.start(config, path: path);
  }

  Future<void> stopAndTranscribeWithDeepInfra() async{
    final now = DateTime.now().millisecondsSinceEpoch;
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/recording.wav';
    await _recorder.stop();
    final result = await NetworkService.transcribeAudio(path);
    final duration = DateTime.now().millisecondsSinceEpoch - now;
    debugPrint("########  DURATION: $duration ########");
    PostHogService.instance.capture(
      PostHogEvents.deepInfraTranscribe,
      properties: {
        'duration': duration,
      },
    );
    if (result != null) {
      globalController.transcriptionText.value = result;
    }
  }
}

class NetworkHelper {
}
