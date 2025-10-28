import 'dart:async';

import 'package:ai_dream_interpretation/app/modules/auth/controllers/auth_controller.dart';
import 'package:ai_dream_interpretation/app/routes/app_pages.dart';
import 'package:ai_dream_interpretation/resources/widgets/chat_input_bar.dart';
import 'package:ai_dream_interpretation/app/modules/home/widgets/messages_list.dart';
import 'package:ai_dream_interpretation/app/modules/home/widgets/home_banner_ad.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/speech_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Obx(() {
          final isPlatinum = authController.userType.value == 'platinum';
          if (!isPlatinum) {
            return IconButton(
              icon: const Icon(Icons.record_voice_over, color: Colors.white),
              onPressed: () {
                Get.snackbar(
                  'Platinum Feature',
                  'Please upgrade to the Platinum plan to change voice types.',
                  mainButton: TextButton(
                    onPressed: () => Get.toNamed('/subscription'),
                    child: const Text('Upgrade'),
                  ),
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            );
          }

          return PopupMenuButton<String>(
            icon: const Icon(Icons.record_voice_over, color: Colors.white),
            onSelected: controller.setSelectedVoice,
            itemBuilder: (BuildContext context) {
              return controller.voiceTypes.map((String voice) {
                return PopupMenuItem<String>(
                  value: voice,
                  child: Text(voice.replaceAll('_', ' ')),
                );
              }).toList();
            },
          );
        }),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: controller.signOut,
          ),
          IconButton(
            icon: const Icon(Icons.subscriptions, color: Colors.white),
            onPressed: () {
              Get.toNamed(Routes.subscription);
            },
          ),
          // Debug-only button to test audio playback pipeline using a public MP3
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              onPressed: () async {
                // Use a local AudioPlayer for isolated debug playback
                const testUrl =
                    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
                final player = AudioPlayer();
                StreamSubscription<PlayerState>? sub;
                try {
                  sub = player.onPlayerStateChanged.listen((state) {
                    if (kDebugMode) print('LocalDebugPlayer: state -> $state');
                  });
                  await player.play(UrlSource(testUrl));
                  Get.snackbar('Debug', 'Local player started (check logs).');
                } catch (e) {
                  Get.snackbar('Debug', 'Local playback failed: $e');
                }

                // cleanup after a reasonable timeout
                Future.delayed(const Duration(seconds: 35), () async {
                  try {
                    await sub?.cancel();
                  } catch (_) {}
                  try {
                    await player.dispose();
                  } catch (_) {}
                  if (kDebugMode) print('LocalDebugPlayer: disposed');
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              final isPlatinum = authController.userType.value == 'platinum';
              if (!isPlatinum) {
                Get.snackbar(
                  'Platinum Feature',
                  'Please upgrade to the Platinum plan to view history.',
                  mainButton: TextButton(
                    onPressed: () => Get.toNamed('/subscription'),
                    child: const Text('Upgrade'),
                  ),
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              Get.toNamed(Routes.history);
            },
          ),
        ],
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background_image.png', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const Expanded(child: MessagesList()),
                const HomeBannerAd(),
                Obx(() {
                  final isTyping = Get.find<ChatController>().isTyping.value;
                  final isListening =
                      Get.find<SpeechController>().isListening.value;
                  return ChatInputBar(
                    textController: controller.textController,
                    onSend: controller.sendMessage,
                    onMicPressed: isListening
                        ? controller.stopListening
                        : () {
                            final isPlatinum =
                                authController.userType.value == 'platinum';
                            if (!isPlatinum) {
                              Get.snackbar(
                                'Platinum Feature',
                                'Please upgrade to the Platinum plan to use the microphone feature.',
                                mainButton: TextButton(
                                  onPressed: () => Get.toNamed('/subscription'),
                                  child: const Text('Upgrade'),
                                ),
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }
                            controller.startListening();
                          },
                    onAttachPressed: () {
                      final isPlatinum =
                          authController.userType.value == 'platinum';
                      if (!isPlatinum) {
                        Get.snackbar(
                          'Platinum Feature',
                          'Please upgrade to the Platinum plan to attach audio.',
                          mainButton: TextButton(
                            onPressed: () => Get.toNamed('/subscription'),
                            child: const Text('Upgrade'),
                          ),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }
                      controller.pickAndTranscribeAudio();
                    },
                    isTyping: isTyping,
                    isListening: isListening,
                    isPlatinum: authController.userType.value == 'platinum',
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
