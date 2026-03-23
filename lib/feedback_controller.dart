import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FeedbackController {
  AudioPlayer? _player;
  bool _hapticInFlight = false;
  bool _soundInFlight = false;
  DateTime? _lastHapticAt;
  DateTime? _lastSoundAt;

  Future<void> warmup() async {
    if (kIsWeb || _player != null) {
      return;
    }

    final player = AudioPlayer();
    await player.setPlayerMode(PlayerMode.lowLatency);
    await player.setReleaseMode(ReleaseMode.stop);
    _player = player;
  }

  void trigger({
    required bool soundEnabled,
    required bool hapticEnabled,
  }) {
    if (hapticEnabled) {
      unawaited(_emitHaptic());
    }
    if (soundEnabled) {
      unawaited(_emitSound());
    }
  }

  Future<void> previewSound() => _emitSound();

  Future<void> previewHaptic() => _emitHaptic();

  Future<void> _emitHaptic() async {
    final now = DateTime.now();
    if (_hapticInFlight) {
      return;
    }
    if (_lastHapticAt != null &&
        now.difference(_lastHapticAt!) < const Duration(milliseconds: 55)) {
      return;
    }

    _hapticInFlight = true;
    _lastHapticAt = now;
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await HapticFeedback.lightImpact();
      } else {
        await HapticFeedback.selectionClick();
      }
    } catch (_) {
      // Ignore feedback failures. UI state should never depend on them.
    } finally {
      _hapticInFlight = false;
    }
  }

  Future<void> _emitSound() async {
    final now = DateTime.now();
    if (_soundInFlight) {
      return;
    }
    if (_lastSoundAt != null &&
        now.difference(_lastSoundAt!) < const Duration(milliseconds: 70)) {
      return;
    }

    _soundInFlight = true;
    _lastSoundAt = now;
    try {
      if (kIsWeb) {
        await SystemSound.play(SystemSoundType.click);
        return;
      }

      await warmup();
      final player = _player;
      if (player == null) {
        return;
      }

      await player.stop();
      await player.play(
        AssetSource('audio/tap.wav'),
        mode: PlayerMode.lowLatency,
        volume: 0.55,
      );
    } catch (_) {
      // Ignore feedback failures. UI state should never depend on them.
    } finally {
      _soundInFlight = false;
    }
  }

  Future<void> dispose() async {
    await _player?.dispose();
  }
}
