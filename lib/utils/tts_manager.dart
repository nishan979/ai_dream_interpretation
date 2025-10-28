// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'package:flutter_tts/flutter_tts.dart';

class TtsManager {
  TtsManager._internal();
  static final TtsManager instance = TtsManager._internal();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  bool _isSpeaking = false; 

  Future<void> init({
    String language = 'en-US',
    double rate = 0.5,
    double volume = 1.0,
    double pitch = 1.0,
  }) async {
    if (_initialized) return;
    try {
      await _tts.setLanguage(language);
      await _tts.setSpeechRate(rate);
      await _tts.setVolume(volume);
      await _tts.setPitch(pitch);

      _tts.setStartHandler(() {
        _isSpeaking = true;
      });
      _tts.setCompletionHandler(() {
        _isSpeaking = false;
      });
      _tts.setErrorHandler((msg) {
        _isSpeaking = false;
      });
    } catch (e) {
      
    }
    _initialized = true;
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    await init();
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
      _isSpeaking = false;
    } catch (e) {
      
    }
  }

  bool get isSpeaking => _isSpeaking;
}
