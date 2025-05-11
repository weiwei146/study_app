import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts flutterTts = FlutterTts();
  Completer<void>? _ttsCompleter;

  Future<void> speakTts(String text) async {
    _ttsCompleter = Completer<void>();
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(0.9);
    await flutterTts.speak(text);
    flutterTts.setCompletionHandler(() {
      _ttsCompleter?.complete();
    });

    return _ttsCompleter!.future;
  }

  void dispose() {
    flutterTts.stop();
  }
}
