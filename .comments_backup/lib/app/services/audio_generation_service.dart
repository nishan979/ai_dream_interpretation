// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com







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

  
  final isPlaying = false.obs;
  final currentPlayingText = ''.obs;

  
  Future<void> togglePlayPause(
    String text,
    String userType,
    String voiceType,
  ) async {
    

    
    if (isPlaying.value && currentPlayingText.value == text) {
      
      await pauseAudio();
      return;
    }

    
    if (isPlaying.value && currentPlayingText.value != text) {
      
      await stopAudio();
    }

    
    
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
    

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    try {
      final accessToken = await _storage.read(key: 'access_token');
      

      final uri = Uri.parse('$baseUrl/chatbot/audio-generate/');
      

      final req = http.MultipartRequest('POST', uri);
      req.fields['text'] = text;
      req.fields['user_type'] = userType;
      req.fields['voice_type'] = voiceType;

      

      if (accessToken != null && accessToken.isNotEmpty) {
        req.headers['Authorization'] = 'Bearer $accessToken';
      } else {
        
      }

      
      
      final streamed = await req.send();

      
      final resp = await http.Response.fromStream(streamed);

      _safeCloseDialog();

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        
        String? audioUrl;
        try {
          final data = json.decode(resp.body);

          if (data is Map && data['audio_url'] != null) {
            audioUrl = data['audio_url'].toString();
          } else if (data is String && data.startsWith('http')) {
            audioUrl = data;
          } else {
            
          }
        } catch (e) {
          
          final candidate = resp.body.trim();
          if (candidate.startsWith('http')) {
            audioUrl = candidate;
            
          } else {
            
          }
        }

        if (audioUrl == null || audioUrl.isEmpty) {
          
          Get.snackbar('Error', 'Audio URL missing in response.');
          return;
        }

        
        String normalizedUrl = audioUrl;
        if (normalizedUrl.startsWith('/')) {
          normalizedUrl =
              baseUrl.replaceAll(RegExp(r'/+$'), '') + normalizedUrl;
        } else if (!normalizedUrl.startsWith('http')) {
          normalizedUrl =
              '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/$normalizedUrl';
        } else if (normalizedUrl.contains('0.0.0.0')) {
          
          normalizedUrl = normalizedUrl.replaceFirst('0.0.0.0', '10.0.2.2');
        } else {
          
        }

        
        
        await _playAudio(normalizedUrl, text);
      } else {
        
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
    

    try {
      
      
      await stopAudio();

      
      
      _currentPlayer = AudioPlayer();

      
      
      await _currentPlayer!.setReleaseMode(ReleaseMode.release);
      
      await _currentPlayer!.setPlayerMode(PlayerMode.mediaPlayer);
      

      currentPlayingText.value = text;
      

      
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

      
      _currentPlayer!.onPlayerComplete.listen((_) {
        isPlaying.value = false;
        currentPlayingText.value = '';
        _currentPlayer?.dispose();
        _currentPlayer = null;
      });

      
      
      _currentPlayer!.onPlayerStateChanged.listen((state) {});

      
      

      
      final bool isNgrok =
          url.contains('ngrok.io') || url.contains('ngrok-free.app');

      if (isNgrok) {
        
        final client = http.Client();
        try {
          
          final response = await client
              .get(
                Uri.parse(url),
                headers: {'Cookie': 'ngrok-skip-browser-warning=true'},
              )
              .timeout(const Duration(seconds: 60));

          if (response.statusCode == 200) {
            final bytes = response.bodyBytes;
            if (bytes.isEmpty) {
              
              Get.snackbar('Error', 'Received empty audio from server');
              isPlaying.value = false;
              currentPlayingText.value = '';
              _currentPlayer?.dispose();
              _currentPlayer = null;
            } else {
              
              await _currentPlayer!.setSourceBytes(bytes);
              await _currentPlayer?.resume();
              
            }
          } else {
            
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
          
          Get.snackbar('Error', 'Could not play audio (network error)');
          isPlaying.value = false;
          currentPlayingText.value = '';
          _currentPlayer?.dispose();
          _currentPlayer = null;
        } finally {
          client.close();
        }
      } else {
        
        
        _currentPlayer!
            .setSource(UrlSource(url))
            .then((_) {
              
              
              return _currentPlayer?.resume();
            })
            .then((_) {
              
            })
            .catchError((error) {
              
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

      
    } catch (e) {
      
      String errorMessage = 'Could not initialize audio player';
      Get.snackbar('Error', errorMessage);
      isPlaying.value = false;
      currentPlayingText.value = '';
      _currentPlayer?.dispose();
      _currentPlayer = null;
      
    }
  }

  Future<void> pauseAudio() async {
    if (_currentPlayer != null) {
      await _currentPlayer!.pause();
      isPlaying.value = false;
    } else {
      
    }
  }

  Future<void> resumeAudio() async {
    if (_currentPlayer != null) {
      await _currentPlayer!.resume();
      isPlaying.value = true;
    } else {
      
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
        
        _currentPlayer = null;
        isPlaying.value = false;
        currentPlayingText.value = '';
      }
    } else {
      
    }
  }

  bool isPlayingText(String text) {
    final result = isPlaying.value && currentPlayingText.value == text;
    
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
