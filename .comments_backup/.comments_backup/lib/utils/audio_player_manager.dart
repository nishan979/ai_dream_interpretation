// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'dart:async';
// (removed unused foundation import)
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

/// A simple singleton manager that encapsulates AudioPlayer lifecycle.
/// Use `AudioPlayerManager.instance.playUrl(url)` to play and
/// `AudioPlayerManager.instance.stop()` to stop.
class AudioPlayerManager {
  AudioPlayerManager._internal();
  static final AudioPlayerManager instance = AudioPlayerManager._internal();

  AudioPlayer? _player;
  StreamSubscription<PlayerState>? _stateSub;

  /// Play a remote URL. Returns when playback has started (player state is playing)
  /// or throws on error/timeout.
  Future<void> playUrl(
    String url, {
    Duration startTimeout = const Duration(seconds: 15),
  }) async {
    // (debug print removed)
    // Quick HEAD check so we fail fast if the resource isn't reachable
    try {
      final head = await http
          .head(Uri.parse(url))
          .timeout(const Duration(seconds: 5));
      if (!(head.statusCode >= 200 && head.statusCode < 300)) {
        throw Exception('Audio URL unreachable: HTTP ${head.statusCode}');
      }
    } catch (e) {
      // (debug print removed)
      throw Exception('Audio URL unreachable: $e');
    }

    // If there's an active player, stop and dispose it first
    await _disposePlayer();

    _player = AudioPlayer();

    try {
      await _player!.play(UrlSource(url));

      // Use a Completer and a subscription so we can detect stream completion
      // and avoid StateError when firstWhere has no matching element.
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
      // ensure we clean up on failure
      await _disposePlayer();
      rethrow;
    }
  }

  /// Non-blocking play method used for debugging: attempts to play and returns
  /// immediately. Useful when the playing-state event is unreliable on a device.
  Future<void> playUrlNoWait(String url) async {
    // (debug print removed)

    // Quick HEAD check
    try {
      final head = await http
          .head(Uri.parse(url))
          .timeout(const Duration(seconds: 5));
      if (!(head.statusCode >= 200 && head.statusCode < 300)) {
        throw Exception('Audio URL unreachable: HTTP ${head.statusCode}');
      }
    } catch (e) {
      // (debug print removed)
      throw Exception('Audio URL unreachable: $e');
    }

    // dispose existing player and create a fresh one
    await _disposePlayer();
    _player = AudioPlayer();

    // keep logging state changes and detect whether we reached playing state
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

    // start playback but don't wait for a playing state; if we don't observe
    // playing within 1.5s, try downloading the file and playing locally.
    try {
      await _player!.play(UrlSource(url));

      // schedule fallback check
      Future.delayed(const Duration(milliseconds: 1500), () async {
        if (startedDetected) return; // success, nothing to do
        // (debug print removed)
        try {
          final resp = await http
              .get(Uri.parse(url))
              .timeout(const Duration(seconds: 15));
          if (resp.statusCode >= 200 && resp.statusCode < 300) {
            final tmp = File(
              '${Directory.systemTemp.path}/debug_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
            );
            await tmp.writeAsBytes(resp.bodyBytes);
            // (debug print removed)

            // stop and dispose current player, then play file
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
            // (debug print removed)
          } else {
            // (debug print removed)
          }
        } catch (e) {
          // (debug print removed)
        }
      });
    } catch (e) {
      await _disposePlayer();
      rethrow;
    }
  }

  /// Stop current playback if any and dispose player
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
    // (debug print removed)
  }

  bool get isPlaying => _player != null;
}
