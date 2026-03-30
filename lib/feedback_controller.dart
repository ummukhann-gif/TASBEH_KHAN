import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class FeedbackController {
  static const _minHapticGap = Duration(milliseconds: 45);
  static const _minSoundGap = Duration(milliseconds: 60);

  AudioPool? _audioPool;
  Future<void>? _warmupFuture;
  Future<bool>? _hasVibratorFuture;
  Future<bool>? _hasAmplitudeControlFuture;
  Future<bool>? _hasCustomVibrationSupportFuture;
  DateTime? _lastHapticAt;
  DateTime? _lastSoundAt;

  Future<void> warmup() async {
    if (kIsWeb) {
      return;
    }

    _warmupFuture ??= _warmupInternal();
    await _warmupFuture;
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

  Future<void> _warmupInternal() async {
    _hasVibratorFuture = Vibration.hasVibrator();
    _hasAmplitudeControlFuture = Vibration.hasAmplitudeControl();
    _hasCustomVibrationSupportFuture = Vibration.hasCustomVibrationsSupport();

    if (_audioPool != null) {
      return;
    }

    _audioPool = await AudioPool.createFromAsset(
      path: 'audio/tap.wav',
      minPlayers: 1,
      maxPlayers: 2,
      playerMode: PlayerMode.lowLatency,
    );
  }

  Future<void> _emitHaptic() async {
    final now = DateTime.now();
    if (_lastHapticAt != null &&
        now.difference(_lastHapticAt!) < _minHapticGap) {
      return;
    }

    _lastHapticAt = now;
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final hasVibrator =
            await (_hasVibratorFuture ??= Vibration.hasVibrator());
        if (!hasVibrator) {
          return;
        }

        final hasCustomSupport = await (_hasCustomVibrationSupportFuture ??=
            Vibration.hasCustomVibrationsSupport());
        if (!hasCustomSupport) {
          await Vibration.vibrate();
          return;
        }

        final hasAmplitudeControl = await (_hasAmplitudeControlFuture ??=
            Vibration.hasAmplitudeControl());
        await Vibration.vibrate(
          duration: 22,
          amplitude: hasAmplitudeControl ? 96 : -1,
        );
        return;
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await HapticFeedback.mediumImpact();
      } else {
        await HapticFeedback.selectionClick();
      }
    } catch (_) {
      // Ignore feedback failures. UI state should never depend on them.
    }
  }

  Future<void> _emitSound() async {
    final now = DateTime.now();
    if (_lastSoundAt != null &&
        now.difference(_lastSoundAt!) < _minSoundGap) {
      return;
    }

    _lastSoundAt = now;
    try {
      if (kIsWeb) {
        await SystemSound.play(SystemSoundType.click);
        return;
      }

      await warmup();
      await _audioPool?.start(volume: 0.8);
    } catch (_) {
      try {
        await SystemSound.play(SystemSoundType.click);
      } catch (_) {
        // Ignore feedback failures. UI state should never depend on them.
      }
    }
  }

  Future<void> dispose() async {
    await _audioPool?.dispose();
  }
}
