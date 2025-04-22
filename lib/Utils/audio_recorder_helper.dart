import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
final StreamController<Uint8List> _audioStreamController = StreamController<Uint8List>.broadcast();

/// Start recording and return a Stream<Uint8List> of raw audio data
Future<Stream<Uint8List>> startRecordingAndGetStream() async {
  // Ask for microphone permission
  var status = await Permission.microphone.request();
  if (!status.isGranted) {
    throw Exception('Microphone permission not granted');
  }

  await _recorder.openRecorder();

  // Start recording, attach the stream sink
  await _recorder.startRecorder(
    toStream: _audioStreamController.sink,
    codec: Codec.pcm16, // 16-bit PCM
    numChannels: 1,     // Mono
    sampleRate: 16000,  // 16 kHz
    bitRate: 256000,
  );

  return _audioStreamController.stream;
}

/// Call this to stop recording cleanly
Future<void> stopRecording() async {
  await _recorder.stopRecorder();
  await _recorder.closeRecorder();
  await _audioStreamController.close();
}
