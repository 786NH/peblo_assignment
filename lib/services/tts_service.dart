import 'dart:ui';

import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();

  Future<void> init() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.4);
    await _tts.setPitch(1.1);
  }

  Future<void> speak(
    String text,
    VoidCallback onComplete,
  ) async {
    _tts.setCompletionHandler(onComplete);

    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}