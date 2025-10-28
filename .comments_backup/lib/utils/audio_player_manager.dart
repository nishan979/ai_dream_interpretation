// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:io';




class AudioPlayerManager {
  AudioPlayerManager._internal();
  static final AudioPlayerManager instance = AudioPlayerManager._internal();

  AudioPlayer? _player;
  StreamSubscription<PlayerState>? _stateSub;

  
  
  Future<void> playUrl(
    String url, {
    Duration startTimeout = const Duration(seconds: 15),
  }) async {
    
    
    try {
      final head = await http
          .head(Uri.parse(url))
          .timeout(const Duration(seconds: 5));
      if (!(head.statusCode >= 200 && head.statusCode < 300)) {
        throw Exception('Audio URL unreachable: HTTP ${head.statusCode}');
      }
    } catch (e) {
      
      throw Exception('Audio URL unreachable: $e');
    }

    
    await _disposePlayer();

    _player = AudioPlayer();

    try {
      await _player!.play(UrlSource(url));

      
      
      final Completer<void> started = Completer<void>();

      _stateSub = _player!.onPlayerStateChanged.listen(
        (state) {
          if (!started.isCompleted && state == PlayerState.playing) {
            started.complete();
          }
        },
        onError: (err) {
          if (!started.isCompleted) {
            started.completeError(Exception('Playback stream error: $err'));
          }
        },
        onDone: () {
          if (!started.isCompleted) {
            started.completeError(
              Exception('No playing state emitted before stream closed'),
            );
          }
        },
        cancelOnError: true,
      );

      try {
        await started.future.timeout(startTimeout);
      } on TimeoutException catch (te) {
        await _disposePlayer();
        throw Exception(
          'Playback timed out waiting for playing state (${te.toString()})',
        );
      } catch (err) {
        await _disposePlayer();
        rethrow;
      }
    } catch (e) {
      
      await _disposePlayer();
      rethrow;
    }
  }

  
  
  Future<void> playUrlNoWait(String url) async {
    

    
    try {
      final head = await http
          .head(Uri.parse(url))
          .timeout(const Duration(seconds: 5));
      if (!(head.statusCode >= 200 && head.statusCode < 300)) {
        throw Exception('Audio URL unreachable: HTTP ${head.statusCode}');
      }
    } catch (e) {
      
      throw Exception('Audio URL unreachable: $e');
    }

    
    await _disposePlayer();
    _player = AudioPlayer();

    
    bool startedDetected = false;
    _stateSub = _player!.onPlayerStateChanged.listen(
      (state) {
        if (!startedDetected && state == PlayerState.playing) {
          startedDetected = true;
        }
      },
      onError: (err) {},
      onDone: () {},
    );

    
    
    try {
      await _player!.play(UrlSource(url));

      
      Future.delayed(const Duration(milliseconds: 1500), () async {
        if (startedDetected) return; 
        
        try {
          final resp = await http
              .get(Uri.parse(url))
              .timeout(const Duration(seconds: 15));
          if (resp.statusCode >= 200 && resp.statusCode < 300) {
            final tmp = File(
              '${Directory.systemTemp.path}/debug_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
            );
            await tmp.writeAsBytes(resp.bodyBytes);
            

            
            try {
              await _player!.stop();
            } catch (_) {}
            try {
              await _player!.dispose();
            } catch (_) {}
            _player = AudioPlayer();
            _stateSub?.cancel();
            _stateSub = _player!.onPlayerStateChanged.listen((state) {});
            await _player!.play(DeviceFileSource(tmp.path));
            
          } else {
            
          }
        } catch (e) {
          
        }
      });
    } catch (e) {
      await _disposePlayer();
      rethrow;
    }
  }

  
  Future<void> stop() async {
    if (_player == null) return;
    try {
      await _player!.stop();
    } catch (_) {}
    await _disposePlayer();
  }

  Future<void> _disposePlayer() async {
    try {
      await _stateSub?.cancel();
    } catch (_) {}
    _stateSub = null;
    try {
      await _player?.dispose();
    } catch (_) {}
    _player = null;
    
  }

  bool get isPlaying => _player != null;
}
