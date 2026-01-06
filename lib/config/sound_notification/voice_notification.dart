import 'package:flutter_tts/flutter_tts.dart';

class VoiceNotification {
  final FlutterTts _tts = FlutterTts();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    await init();
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  void dispose() {
    _tts.stop();
  }

}
