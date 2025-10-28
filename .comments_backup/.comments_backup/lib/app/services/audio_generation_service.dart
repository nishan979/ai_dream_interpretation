// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

//-------------------------------------------------------------
// DEVELOPER: Shahadat Hosen Nishan || JVai
// DATE: October 20, 2025
// PROJECT: Ai Dream Interpretation
// -------------------------------------------------------------

import 'dart:convert';
import 'dart:async';
import 'package:ai_dream_interpretation/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ai_dream_interpretation/utils/ui_utils.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioGenerationService extends GetxController {
  final _storage = const FlutterSecureStorage();
  AudioPlayer? _currentPlayer;

  // Observable for tracking playing state
  final isPlaying = false.obs;
  final currentPlayingText = ''.obs;

  // Toggle play/pause for a specific text
  Future<void> togglePlayPause(
    String text,
    String userType,
    String voiceType,
  ) async {
    // (debug prints removed)

    // If currently playing this text, pause it
    if (isPlaying.value && currentPlayingText.value == text) {
      // (debug print removed)
      await pauseAudio();
      return;
    }

    // If playing different text, stop it first
    if (isPlaying.value && currentPlayingText.value != text) {
      // (debug print removed)
      await stopAudio();
    }

    // Generate and play the audio
    // (debug print removed)
    await generateAndPlayAudio(
      text: text,
      userType: userType,
      voiceType: voiceType,
    );
  }

  Future<void> generateAndPlayAudio({
    required String text,
    required String userType,
    required String voiceType,
  }) async {
    // (debug prints removed)

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    try {
      final accessToken = await _storage.read(key: 'access_token');
      // (debug print removed)

      final uri = Uri.parse('$baseUrl/chatbot/audio-generate/');
      // (debug print removed)

      final req = http.MultipartRequest('POST', uri);
      req.fields['text'] = text;
      req.fields['user_type'] = userType;
      req.fields['voice_type'] = voiceType;

      // (debug prints removed)

      if (accessToken != null && accessToken.isNotEmpty) {
        req.headers['Authorization'] = 'Bearer $accessToken';
      } else {
        // (debug print removed)
      }

      // Send request without timeout
      // (debug prints removed)
      final streamed = await req.send();

      // Convert to response without timeout
      final resp = await http.Response.fromStream(streamed);

      _safeCloseDialog();

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        // (debug print removed)
        String? audioUrl;
        try {
          final data = json.decode(resp.body);

          if (data is Map && data['audio_url'] != null) {
            audioUrl = data['audio_url'].toString();
          } else if (data is String && data.startsWith('http')) {
            audioUrl = data;
          } else {
            // (debug print removed)
          }
        } catch (e) {
          // (debug print removed)
          final candidate = resp.body.trim();
          if (candidate.startsWith('http')) {
            audioUrl = candidate;
            // (debug print removed)
          } else {
            // (debug print removed)
          }
        }

        if (audioUrl == null || audioUrl.isEmpty) {
          // (debug print removed)
          Get.snackbar('Error', 'Audio URL missing in response.');
          return;
        }

        // Normalize relative or non-http URLs returned by server
        String normalizedUrl = audioUrl;
        if (normalizedUrl.startsWith('/')) {
          normalizedUrl =
              baseUrl.replaceAll(RegExp(r'/+$'), '') + normalizedUrl;
        } else if (!normalizedUrl.startsWith('http')) {
          normalizedUrl =
              '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/$normalizedUrl';
        } else if (normalizedUrl.contains('0.0.0.0')) {
          // Replace 0.0.0.0 with 10.0.2.2 for emulator
          normalizedUrl = normalizedUrl.replaceFirst('0.0.0.0', '10.0.2.2');
        } else {
          // (debug print removed)
        }

        // Play the audio
        // (debug print removed)
        await _playAudio(normalizedUrl, text);
      } else {
        // (debug print removed)
        Get.snackbar(
          'Error',
          'Could not generate audio. Status: ${resp.statusCode}',
        );
      }
    } catch (e) {
      _safeCloseDialog();
      Get.snackbar('Error', 'An unexpected error occurred: ${e.toString()}');
      return;
    }
  }

  Future<void> _playAudio(String url, String text) async {
    // (debug prints removed)

    try {
      // Stop any existing player
      // (debug print removed)
      await stopAudio();

      // Create new player
      // (debug print removed)
      _currentPlayer = AudioPlayer();

      // Configure player for streaming with no timeout
      // (debug print removed)
      await _currentPlayer!.setReleaseMode(ReleaseMode.release);
      // Set player mode to low latency (better for streaming)
      await _currentPlayer!.setPlayerMode(PlayerMode.mediaPlayer);
      // (debug print removed)

      currentPlayingText.value = text;
      // (debug print removed)

      // Listen to player state changes
      _currentPlayer!.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.playing) {
          isPlaying.value = true;
        } else if (state == PlayerState.paused) {
          isPlaying.value = false;
        } else if (state == PlayerState.completed ||
            state == PlayerState.stopped) {
          isPlaying.value = false;
          currentPlayingText.value = '';
        }
      });

      // Listen to completion
      _currentPlayer!.onPlayerComplete.listen((_) {
        isPlaying.value = false;
        currentPlayingText.value = '';
        _currentPlayer?.dispose();
        _currentPlayer = null;
      });

      // Listen for errors
      // (debug print removed)
      _currentPlayer!.onPlayerStateChanged.listen((state) {});

      // Set the audio source and play immediately (without awaiting to avoid timeout)
      // (debug print removed)

      // If URL likely served through ngrok, always fetch bytes with the ngrok cookie and play from memory.
      final bool isNgrok =
          url.contains('ngrok.io') || url.contains('ngrok-free.app');

      if (isNgrok) {
        // (debug print removed)
        final client = http.Client();
        try {
          // Increase timeout to 60s for slow connections
          final response = await client
              .get(
                Uri.parse(url),
                headers: {'Cookie': 'ngrok-skip-browser-warning=true'},
              )
              .timeout(const Duration(seconds: 60));

          if (response.statusCode == 200) {
            final bytes = response.bodyBytes;
            if (bytes.isEmpty) {
              // (debug print removed)
              Get.snackbar('Error', 'Received empty audio from server');
              isPlaying.value = false;
              currentPlayingText.value = '';
              _currentPlayer?.dispose();
              _currentPlayer = null;
            } else {
              // (debug print removed)
              await _currentPlayer!.setSourceBytes(bytes);
              await _currentPlayer?.resume();
              // (debug print removed)
            }
          } else {
            // (debug print removed)
            Get.snackbar(
              'Error',
              'Could not play audio (status: ${response.statusCode})',
            );
            isPlaying.value = false;
            currentPlayingText.value = '';
            _currentPlayer?.dispose();
            _currentPlayer = null;
          }
        } catch (e) {
          // (debug print removed)
          Get.snackbar('Error', 'Could not play audio (network error)');
          isPlaying.value = false;
          currentPlayingText.value = '';
          _currentPlayer?.dispose();
          _currentPlayer = null;
        } finally {
          client.close();
        }
      } else {
        // Non-ngrok: normal setSource (no special headers)
        // Don't await - let it load and play asynchronously
        _currentPlayer!
            .setSource(UrlSource(url))
            .then((_) {
              // (debug print removed)
              // Start playing
              return _currentPlayer?.resume();
            })
            .then((_) {
              // (debug print removed)
            })
            .catchError((error) {
              // (debug print removed)
              if (_currentPlayer != null) {
                String errorMessage = 'Could not play audio';
                if (error.toString().contains('404')) {
                  errorMessage = 'Audio file not found on server.';
                } else if (error.toString().contains('Connection')) {
                  errorMessage = 'Network connection error.';
                }
                Get.snackbar('Error', errorMessage);
                isPlaying.value = false;
                currentPlayingText.value = '';
                _currentPlayer?.dispose();
                _currentPlayer = null;
              }
            });
      }

      // (debug prints removed)
    } catch (e) {
      // (debug prints removed)
      String errorMessage = 'Could not initialize audio player';
      Get.snackbar('Error', errorMessage);
      isPlaying.value = false;
      currentPlayingText.value = '';
      _currentPlayer?.dispose();
      _currentPlayer = null;
      // (debug print removed)
    }
  }

  Future<void> pauseAudio() async {
    if (_currentPlayer != null) {
      await _currentPlayer!.pause();
      isPlaying.value = false;
    } else {
      // (debug print removed)
    }
  }

  Future<void> resumeAudio() async {
    if (_currentPlayer != null) {
      await _currentPlayer!.resume();
      isPlaying.value = true;
    } else {
      // (debug print removed)
    }
  }

  Future<void> stopAudio() async {
    if (_currentPlayer != null) {
      try {
        await _currentPlayer!.stop();
        await _currentPlayer!.dispose();
        _currentPlayer = null;
        isPlaying.value = false;
        currentPlayingText.value = '';
      } catch (e) {
        // (debug print removed)
        _currentPlayer = null;
        isPlaying.value = false;
        currentPlayingText.value = '';
      }
    } else {
      // (debug print removed)
    }
  }

  bool isPlayingText(String text) {
    final result = isPlaying.value && currentPlayingText.value == text;
    // (debug print removed)
    return result;
  }

  void _safeCloseDialog() {
    UiUtils.safeDismiss();
  }

  @override
  void onClose() {
    stopAudio();
    super.onClose();
  }
}
