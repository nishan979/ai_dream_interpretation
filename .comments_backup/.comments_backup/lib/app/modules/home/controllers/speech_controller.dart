// ignore_for_file: deprecated_member_use

import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechController extends GetxController {
  final SpeechToText _speechToText = SpeechToText();
  final isListening = false.obs;
  bool _speechEnabled = false;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
    // (debug prints removed)
  }

  Future<void> _initSpeech() async {
    // (debug prints removed)
    try {
      // (debug prints removed)
      await _speechToText.hasPermission;

      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) {
          // (debug print removed)
          if (status == SpeechToText.doneStatus ||
              status == SpeechToText.notListeningStatus) {
            // (debug print removed)
            isListening.value = false;
          }
        },
        onError: (error) {
          // (debug print removed)
          isListening.value = false;
        },
        debugLogging: true,
      );

      // (debug prints removed)

      try {
        await _speechToText.systemLocale();
        await _speechToText.locales();
      } catch (e) {
        // (debug print removed)
      }
    } catch (e) {
      _speechEnabled = false;
      // (debug print removed)
    }
    // (debug print removed)
  }

  void startListening({required Function(String) onResult}) async {
    // (debug print removed)

    if (!_speechEnabled) {
      // (debug print removed)
      return;
    }
    if (isListening.value) {
      // (debug print removed)
      return;
    }
    bool hasPermission = await _speechToText.hasPermission;
    // (debug print removed)
    if (!hasPermission) {
      // (debug print removed)
      await _initSpeech();
      if (!await _speechToText.hasPermission) {
        // (debug print removed)
        return;
      }
    }

    isListening.value = true;
    // (debug print removed)

    try {
      bool gotAnyResult = false;
      final sys = await _speechToText.systemLocale();
      final localeToUse = sys?.localeId ?? 'en_US';
      // (debug print removed)

      // small delay prevents race conditions
      await Future.delayed(const Duration(milliseconds: 300));

      // (debug print removed)
      _speechToText.listen(
        onResult: (result) {
          // (debug print removed)
          gotAnyResult = true;
          if (result.finalResult) {
            final recognizedText = result.recognizedWords;
            // (debug print removed)
            if (recognizedText.isNotEmpty) {
              try {
                onResult(recognizedText);
              } catch (e) {
                // (debug print removed)
              }
            } else {
              // (debug print removed)
            }
          }
        },
        onSoundLevelChange: (level) {
          // (debug print removed)
        },
        pauseFor: const Duration(seconds: 5),
        listenFor: const Duration(seconds: 30),
        partialResults: true,
        localeId: localeToUse,
        listenMode: ListenMode.dictation,
        cancelOnError: true,
      );

      // (debug prints removed)
      await Future.delayed(const Duration(milliseconds: 500));

      // Watchdog to detect silent recognizer
      Future.delayed(const Duration(seconds: 6), () async {
        final stillListening = _speechToText.isListening;
        // (debug prints removed)
        if (!gotAnyResult && stillListening) {
          // (debug prints removed)
          await _speechToText.stop();
        }
      });
    } catch (e) {
      // (debug print removed)
      isListening.value = false;
    }

    // (debug print removed)
  }

  Future<void> stopListening() async {
    try {
      await _speechToText.stop();
      isListening.value = false;
    } catch (e) {
      // (debug print removed)
      isListening.value = false;
    }
  }
}
