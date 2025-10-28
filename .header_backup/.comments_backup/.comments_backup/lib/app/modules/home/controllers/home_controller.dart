//-------------------------------------------------------------
// DEVELOPER: Shahadat Hosen Nishan || JVai
// DATE: August 17, 2025
// PROJECT: Ai Dream Interpretation
// -------------------------------------------------------------

import 'dart:convert';
import 'dart:async';

import 'package:ai_dream_interpretation/constants.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ai_dream_interpretation/app/modules/auth/controllers/auth_controller.dart';
import 'package:ai_dream_interpretation/app/modules/home/controllers/chat_controller.dart';
import 'package:ai_dream_interpretation/app/modules/home/controllers/speech_controller.dart';
import 'package:ai_dream_interpretation/app/modules/home/controllers/ad_controller.dart';
import 'package:ai_dream_interpretation/app/modules/home/controllers/voice_controller.dart';
import 'package:ai_dream_interpretation/app/services/audio_generation_service.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final AuthController _authController = Get.find();
  late final ChatController chatController;
  late final SpeechController speechController;
  late final AdController adController;
  late final VoiceController voiceController;
  late final AudioGenerationService audioService;

  late TextEditingController textController;
  bool hasAnswered = false;

  final voiceTypes = <String>[].obs;
  final selectedVoice = 'Soothing_female'.obs;

  @override
  void onInit() {
    super.onInit();
    // Register subcontrollers as permanent so they aren't deleted unexpectedly
    chatController = Get.put(ChatController(), permanent: true);
    speechController = Get.put(SpeechController(), permanent: true);
    adController = Get.put(AdController(), permanent: true);
    voiceController = Get.put(VoiceController(), permanent: true);
    audioService = Get.put(AudioGenerationService(), permanent: true);

    textController = TextEditingController();
    adController.loadBanner('ca-app-pub-2660424374100088/1704702903');
    textController.addListener(_onTextChanged);
    _fetchVoiceTypes();
  }

  void _fetchVoiceTypes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chatbot/voice-types/'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<String> fetchedVoices = List<String>.from(
          data['available_voice_types'],
        );
        voiceTypes.value = fetchedVoices;
      }
    } catch (e) {
      // (debug print removed)
    }
  }

  void setSelectedVoice(String type) {
    selectedVoice.value = type;
    Get.snackbar('Voice Changed', 'Voice changed to $type');
  }

  void toggleReadAloud(String text) {
    text = text.trim();
    if (text.isEmpty) {
      return;
    }
    if (_authController.userType.value != 'platinum') {
      _showUpgradeSnackbar();
      return;
    }
    audioService.togglePlayPause(
      text,
      _authController.userType.value,
      selectedVoice.value,
    );
  }

  bool isTextPlaying(String text) {
    return audioService.isPlayingText(text);
  }

  // --- Helper for showing upgrade message ---
  void _showUpgradeSnackbar() {
    Get.snackbar(
      'Platinum Feature',
      'Please upgrade to the Platinum plan to use this feature.',
      mainButton: TextButton(
        onPressed: () => Get.toNamed('/subscription'),
        child: const Text('Upgrade'),
      ),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Speech initialization handled by SpeechController
  void startListening() async {
    // (debug prints removed)
    if (_authController.userType.value != 'platinum') {
      // (debug print removed)
      _showUpgradeSnackbar();
      return;
    }
    // (debug print removed)
    try {
      speechController.startListening(
        onResult: (recognized) {
          // (debug print removed)
          final trimmed = recognized.trim();
          if (trimmed.isEmpty) {
            // (debug print removed)
            return;
          }
          try {
            chatController.sendMessage(text: recognized);
            // (debug print removed)
          } catch (e) {
            // (debug print removed)
          }
        },
      );
      // (debug print removed)
    } catch (e) {
      // (debug print removed)
      Get.snackbar('Error', 'Could not start listening.');
    }
  }

  //-------------------- Audio File Pick + Transcribe -------------------------

  Future<void> pickAndTranscribeAudio() async {
    if (_authController.userType.value != 'platinum') {
      _showUpgradeSnackbar();
      return;
    }

    await chatController.pickAndTranscribeAudio();
  }

  //-------------------- Audio File Pick End -------------------------

  void stopListening() async {
    // (debug prints removed)
    try {
      await speechController.stopListening();
    } catch (e) {
      Get.snackbar('Error', 'Could not stop listening.');
    }
  }

  void _onTextChanged() {
    chatController.setTyping(textController.text.isNotEmpty);
  }

  void sendMessage() {
    final text = textController.text;
    if (text.isEmpty) return;
    chatController.sendMessage(text: text);
    textController.clear();
  }

  // ---------------- Dream Flow Message Logic ----------------
  // Message sending delegated to ChatController

  //--------------------- Nishan Logout start ---------------------

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Could not sign out. Please try again.');
    }
  }

  //--------------------- Nishan Logout End ---------------------

  @override
  void onClose() {
    textController.removeListener(_onTextChanged);
    // textController.dispose();
    // AdController will dispose its banner in its onClose
    super.onClose();
  }
}
