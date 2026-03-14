import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Services/network_service.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';

class AudioChunkRecorder {
  final _recorder = AudioRecorder();
  VoiceActivityDetector? _vad;
  StreamSubscription<Uint8List>? _recordingStream;
   // Buffer for accumulating PCM samples that don't align to windowSize
  final List<double> _sampleBuffer = [];

  bool isRecording = false;

  final config = RecordConfig(
    encoder: AudioEncoder.pcm16bits,
    sampleRate: 16000,
    numChannels: 1,
  );

  Future<void> initializeVad() async {
    final docDirectory = (await getApplicationDocumentsDirectory()).path;
    final sileroModel = "$docDirectory/canary/silero_vad.onnx";
    _vad = VoiceActivityDetector(
      config: VadModelConfig(
        sileroVad: SileroVadModelConfig(
          model: sileroModel,
          minSilenceDuration: 0.5,
          minSpeechDuration: 0.25,
          threshold: 0.3,
        ),
        sampleRate: 16000,
        numThreads: 1,
        debug: false,
      ),
      bufferSizeInSeconds: 30,
    );
  }

  Future<void> startRecording() async {
    if (isRecording) return;

    isRecording = true;
    globalController.isLastChunkTranscribed.value = false;
    await initializeVad();
    final stream = await _recorder.startStream(config);

    try{
      _recordingStream = stream.listen((data) {
    final floatSamples = _pcm16ToFloat32(data);
    _sampleBuffer.addAll(floatSamples);
    const windowSize = 512;
    while (_sampleBuffer.length >= windowSize) {
      final chunk = Float32List.fromList(_sampleBuffer.sublist(0, windowSize));
      _vad?.acceptWaveform(chunk);
      _sampleBuffer.removeRange(0, windowSize);
      _processVadSegments();
    }
    });
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.audioError,
        errorMessage: e.toString(),
        location: 'AudioChunkRecorder.startRecording',
      );
      debugPrint(e.toString());
    }
  }

  Future<void> _processVadSegments() async{
    while (!_vad!.isEmpty()) {
      final segment = _vad!.front();
      _vad!.pop();
      transcribeWithPersistentIsolate(segment.samples);
    }
  }

  Float32List _pcm16ToFloat32(Uint8List bytes) {
    // Copy to a fresh buffer to guarantee 2-byte alignment
    final aligned = Uint8List.fromList(bytes);
    final int16 = aligned.buffer.asInt16List(0, aligned.length ~/ 2);
    return Float32List.fromList(
      int16.map((s) => s / 32768.0).toList(),
    );
  }

  Future<void> stop({bool isFromLesson = false}) async {
    if (!isRecording) return;

    isRecording = false;

    await _recordingStream?.cancel();
    _recordingStream = null;

    await _recorder.stop();

    // Flush remaining audio through VAD
    _vad!.flush();
    final segment = _vad!.front();
    _vad!.reset();
    await transcribeWithPersistentIsolate(segment.samples);
    _sampleBuffer.clear();

    globalController.isLastChunkTranscribed.value = true;
    debugPrint("last recording transcribed");
  }

  Future<void> transcribeWithPersistentIsolate(
    Float32List samples
  ) async {
    if (samples.isNotEmpty) {

      final ReceivePort responsePort = ReceivePort();

      globalController.whisperSendPort?.send({
        'samples': samples,
        'replyTo': responsePort.sendPort,
      });

      final result = await responsePort.first;
      debugPrint('TRANSCRIBED: $result');
      globalController.transcriptionText.value += result;
    }
  }

  Future<void> stopAndTranscribeWithDeepInfra() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/recording.wav';
    await _recorder.stop();
    final result = await NetworkService.transcribeAudio(path);
    final duration = DateTime.now().millisecondsSinceEpoch - now;
    debugPrint("########  DURATION: $duration ########");
    PostHogService.instance.capture(
      PostHogEvents.deepInfraTranscribe,
      properties: {'duration': duration},
    );
    if (result != null) {
      globalController.transcriptionText.value = result;
    }
  }
}