

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
    
  }

  Future<void> _initSpeech() async {
    
    try {
      
      await _speechToText.hasPermission;

      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) {
          
          if (status == SpeechToText.doneStatus ||
              status == SpeechToText.notListeningStatus) {
            
            isListening.value = false;
          }
        },
        onError: (error) {
          
          isListening.value = false;
        },
        debugLogging: true,
      );

      

      try {
        await _speechToText.systemLocale();
        await _speechToText.locales();
      } catch (e) {
        
      }
    } catch (e) {
      _speechEnabled = false;
      
    }
    
  }

  void startListening({required Function(String) onResult}) async {
    

    if (!_speechEnabled) {
      
      return;
    }
    if (isListening.value) {
      
      return;
    }
    bool hasPermission = await _speechToText.hasPermission;
    
    if (!hasPermission) {
      
      await _initSpeech();
      if (!await _speechToText.hasPermission) {
        
        return;
      }
    }

    isListening.value = true;
    

    try {
      bool gotAnyResult = false;
      final sys = await _speechToText.systemLocale();
      final localeToUse = sys?.localeId ?? 'en_US';
      

      
      await Future.delayed(const Duration(milliseconds: 300));

      
      _speechToText.listen(
        onResult: (result) {
          
          gotAnyResult = true;
          if (result.finalResult) {
            final recognizedText = result.recognizedWords;
            
            if (recognizedText.isNotEmpty) {
              try {
                onResult(recognizedText);
              } catch (e) {
                
              }
            } else {
              
            }
          }
        },
        onSoundLevelChange: (level) {
          
        },
        pauseFor: const Duration(seconds: 5),
        listenFor: const Duration(seconds: 30),
        partialResults: true,
        localeId: localeToUse,
        listenMode: ListenMode.dictation,
        cancelOnError: true,
      );

      
      await Future.delayed(const Duration(milliseconds: 500));

      
      Future.delayed(const Duration(seconds: 6), () async {
        final stillListening = _speechToText.isListening;
        
        if (!gotAnyResult && stillListening) {
          
          await _speechToText.stop();
        }
      });
    } catch (e) {
      
      isListening.value = false;
    }

    
  }

  Future<void> stopListening() async {
    try {
      await _speechToText.stop();
      isListening.value = false;
    } catch (e) {
      
      isListening.value = false;
    }
  }
}
