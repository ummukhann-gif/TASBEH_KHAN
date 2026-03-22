import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import 'app_strings.dart';
import 'theme.dart';

class TasbihAppState extends ChangeNotifier {
  TasbihAppState._();

  static const _prefsKey = 'terra_tasbih_state_v3';

  final List<DhikrDefinition> _builtInDhikrs = const [
    DhikrDefinition(
      id: 'subhanallah',
      title: 'Subhanallah',
      arabic:
          'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ وَرِضَا نَفْسِهِ وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ',
      transliteration:
          "Subhanallahi wa bihamdihi, 'adada khalqihi, wa rida nafsihi, wa zinata 'arshihi, wa midada kalimatihi",
      translation:
          'Glory be to Allah and His is the praise, as many times as the number of His creation.',
      category: 'Morning',
      suggestedTarget: 33,
    ),
    DhikrDefinition(
      id: 'alhamdulillah',
      title: 'Alhamdulillah',
      arabic: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'Alhamdulillah',
      translation: 'All praise is due to Allah.',
      category: 'Praise',
      suggestedTarget: 33,
    ),
    DhikrDefinition(
      id: 'allahu-akbar',
      title: 'Allahu Akbar',
      arabic: 'اللهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      translation: 'Allah is the Greatest.',
      category: 'Magnification',
      suggestedTarget: 34,
    ),
    DhikrDefinition(
      id: 'astaghfirullah',
      title: 'Astaghfirullah',
      arabic: 'أَسْتَغْفِرُ اللهَ',
      transliteration: 'Astaghfirullah',
      translation: 'I seek forgiveness from Allah.',
      category: 'Forgiveness',
      suggestedTarget: 100,
    ),
  ];

  List<CustomDhikr> _customDhikrs = [];
  List<SessionRecord> _sessions = [];
  String _currentDhikrId = 'subhanallah';
  int _currentCount = 0;
  int _goalPreset = 0;
  bool _currentSessionCompleted = false;
  bool _soundEnabled = false;
  bool _hapticsEnabled = true;
  bool _darkModeEnabled = false;
  double _textScale = 1.0;
  AppLanguage _language = AppLanguage.english;
  AppPalette _palette = AppPalette.terra;
  DateTime? _currentSessionStartedAt;
  AudioPlayer? _feedbackPlayer;

  static Future<TasbihAppState> load() async {
    final state = TasbihAppState._();
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);

    if (raw == null) {
      return state;
    }

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      state._customDhikrs =
          ((json['customDhikrs'] as List<dynamic>? ?? const []))
              .map((item) => CustomDhikr.fromJson(item as Map<String, dynamic>))
              .toList();
      state._sessions =
          ((json['sessions'] as List<dynamic>? ?? const []))
              .map(
                (item) => SessionRecord.fromJson(item as Map<String, dynamic>),
              )
              .toList()
            ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
      state._currentDhikrId =
          json['currentDhikrId'] as String? ?? state._currentDhikrId;
      state._currentCount = json['currentCount'] as int? ?? 0;
      state._goalPreset = json['goalPreset'] as int? ?? 0;
      state._currentSessionCompleted =
          json['currentSessionCompleted'] as bool? ?? false;
      state._soundEnabled = json['soundEnabled'] as bool? ?? false;
      state._hapticsEnabled = json['hapticsEnabled'] as bool? ?? true;
      state._darkModeEnabled = json['darkModeEnabled'] as bool? ?? false;
      state._textScale = (json['textScale'] as num?)?.toDouble() ?? 1.0;

      final languageName = json['language'] as String?;
      if (languageName != null) {
        state._language = AppLanguage.values.firstWhere(
          (value) => value.name == languageName,
          orElse: () => AppLanguage.english,
        );
      }

      final paletteName = json['palette'] as String?;
      if (paletteName != null) {
        state._palette = AppPalette.values.firstWhere(
          (value) => value.name == paletteName,
          orElse: () => AppPalette.terra,
        );
      }

      final startedAt = json['currentSessionStartedAt'] as String?;
      state._currentSessionStartedAt = startedAt == null
          ? null
          : DateTime.tryParse(startedAt)?.toLocal();
    } catch (_) {
      return state;
    }

    if (!state.allDhikrs.any((dhikr) => dhikr.id == state._currentDhikrId)) {
      state._currentDhikrId = state._builtInDhikrs.first.id;
      state._currentCount = 0;
      state._currentSessionCompleted = false;
      state._currentSessionStartedAt = null;
    }

    return state;
  }

  List<DhikrDefinition> get allDhikrs => [..._builtInDhikrs, ..._customDhikrs];
  List<SessionRecord> get sessions => List.unmodifiable(_sessions);
  AppLanguage get language => _language;
  AppPalette get palette => _palette;
  double get textScale => _textScale;
  bool get darkModeEnabled => _darkModeEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get hapticsEnabled => _hapticsEnabled;
  int get currentCount => _currentCount;
  int get goalPreset => _goalPreset;
  bool get currentSessionCompleted => _currentSessionCompleted;

  DhikrDefinition get currentDhikr {
    return allDhikrs.firstWhere(
      (item) => item.id == _currentDhikrId,
      orElse: () => _builtInDhikrs.first,
    );
  }

  AppStrings get strings => AppStrings(_language);

  int? get currentTarget {
    if (_goalPreset == -1) {
      return null;
    }
    return _goalPreset == 0 ? currentDhikr.suggestedTarget : _goalPreset;
  }

  String get currentTargetLabel => currentTarget?.toString() ?? '∞';

  bool get isGoalReached {
    final target = currentTarget;
    if (target == null) {
      return false;
    }
    return _currentCount >= target;
  }

  bool get hasLiveSession => _currentCount > 0 && !_currentSessionCompleted;

  double get progress {
    final target = currentTarget;
    if (target == null || target == 0) {
      return 0;
    }
    return (_currentCount / target).clamp(0, 1).toDouble();
  }

  int get liveContribution => _currentSessionCompleted ? 0 : _currentCount;
  int get totalCount =>
      _sessions.fold<int>(0, (sum, item) => sum + item.count) +
      liveContribution;

  Duration get totalDuration {
    final saved = _sessions.fold<Duration>(
      Duration.zero,
      (sum, item) => sum + item.duration,
    );

    if (!hasLiveSession || _currentSessionStartedAt == null) {
      return saved;
    }

    return saved + DateTime.now().difference(_currentSessionStartedAt!);
  }

  int get activeStreak {
    final activeDays = <DateTime>{
      ..._sessions.map((session) => _dateOnly(session.completedAt)),
      if (_currentCount > 0) _dateOnly(DateTime.now()),
    }.toList()..sort((a, b) => b.compareTo(a));

    if (activeDays.isEmpty) {
      return 0;
    }

    var streak = 0;
    var cursor = _dateOnly(DateTime.now());

    for (final day in activeDays) {
      if (day == cursor) {
        streak += 1;
        cursor = cursor.subtract(const Duration(days: 1));
      } else if (day.isBefore(cursor)) {
        break;
      }
    }

    return streak;
  }

  int get todayCount => _countForDay(DateTime.now());

  int get todaySessionCount {
    final today = _dateOnly(DateTime.now());
    final saved = _sessions
        .where((item) => _dateOnly(item.completedAt) == today)
        .length;
    return saved + (hasLiveSession ? 1 : 0);
  }

  Duration get todayDuration {
    final today = _dateOnly(DateTime.now());
    final saved = _sessions
        .where((item) => _dateOnly(item.completedAt) == today)
        .fold<Duration>(Duration.zero, (sum, item) => sum + item.duration);

    if (!hasLiveSession || _currentSessionStartedAt == null) {
      return saved;
    }

    return saved + DateTime.now().difference(_currentSessionStartedAt!);
  }

  List<DailyCount> get weeklyCounts {
    final now = _dateOnly(DateTime.now());
    return List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      return DailyCount(day: day, count: _countForDay(day));
    });
  }

  int get weekChangePercent {
    final values = weeklyCounts;
    final firstHalf = values
        .take(3)
        .fold<int>(0, (sum, item) => sum + item.count);
    final secondHalf = values
        .skip(3)
        .fold<int>(0, (sum, item) => sum + item.count);

    if (firstHalf == 0) {
      return secondHalf == 0 ? 0 : 100;
    }

    return (((secondHalf - firstHalf) / firstHalf) * 100).round();
  }

  Future<void> incrementCount() async {
    if (_currentSessionCompleted) {
      return;
    }

    _currentSessionStartedAt ??= DateTime.now();
    _currentCount += 1;
    notifyListeners();
    _triggerFeedback();

    final target = currentTarget;
    if (target != null && _currentCount >= target) {
      _archiveCurrentSession(goalReached: true);
      _currentSessionCompleted = true;
      _currentSessionStartedAt = null;
      notifyListeners();
    }

    unawaited(_persist());
  }

  void resetCurrentSession() {
    if (_currentCount == 0) {
      return;
    }

    if (!_currentSessionCompleted) {
      _archiveCurrentSession(goalReached: false);
    }

    _currentCount = 0;
    _currentSessionCompleted = false;
    _currentSessionStartedAt = null;
    _touch();
  }

  void undoCount() {
    if (_currentCount == 0 || _currentSessionCompleted) {
      return;
    }

    _currentCount -= 1;
    if (_currentCount == 0) {
      _currentSessionStartedAt = null;
    }
    _touch();
  }

  void selectDhikr(String id) {
    if (_currentDhikrId == id) {
      return;
    }

    if (hasLiveSession) {
      _archiveCurrentSession(goalReached: false);
    }

    _currentDhikrId = id;
    _currentCount = 0;
    _currentSessionCompleted = false;
    _currentSessionStartedAt = null;
    _touch();
  }

  void setGoalPreset(int value) {
    _goalPreset = value;

    final target = currentTarget;
    if (target != null &&
        _currentCount >= target &&
        !_currentSessionCompleted) {
      _archiveCurrentSession(goalReached: true);
      _currentSessionCompleted = true;
      _currentSessionStartedAt = null;
    } else if (_currentSessionCompleted && target == null) {
      _currentSessionCompleted = false;
    }

    _touch();
  }

  void setSoundEnabled(bool value) {
    _soundEnabled = value;
    if (value) {
      unawaited(_playTapSound());
    }
    _touch();
  }

  void setHapticsEnabled(bool value) {
    _hapticsEnabled = value;
    if (value) {
      unawaited(_triggerHaptics());
    }
    _touch();
  }

  void setDarkModeEnabled(bool value) {
    _darkModeEnabled = value;
    _touch();
  }

  void setTextScale(double value) {
    _textScale = value.clamp(0.9, 1.3);
    _touch();
  }

  void setLanguage(AppLanguage value) {
    _language = value;
    _touch();
  }

  void setPalette(AppPalette value) {
    _palette = value;
    _touch();
  }

  String addCustomDhikr({
    required String title,
    required String arabic,
    required int target,
  }) {
    final id =
        '${title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}-${DateTime.now().millisecondsSinceEpoch}';

    _customDhikrs = [
      CustomDhikr(
        id: id,
        title: title.trim(),
        arabic: arabic.trim(),
        transliteration: title.trim(),
        translation: 'Custom dhikr',
        category: 'Custom',
        suggestedTarget: target,
      ),
      ..._customDhikrs,
    ];
    _touch();
    return id;
  }

  void removeCustomDhikr(String id) {
    _customDhikrs.removeWhere((item) => item.id == id);
    _sessions.removeWhere((item) => item.dhikrId == id);
    if (_currentDhikrId == id) {
      _currentDhikrId = _builtInDhikrs.first.id;
      _currentCount = 0;
      _currentSessionCompleted = false;
      _currentSessionStartedAt = null;
    }
    _touch();
  }

  void resetAllProgress() {
    _sessions = [];
    _currentCount = 0;
    _currentSessionCompleted = false;
    _currentSessionStartedAt = null;
    _goalPreset = 0;
    _touch();
  }

  String labelForDhikr(String dhikrId) {
    return allDhikrs
        .firstWhere((item) => item.id == dhikrId, orElse: () => currentDhikr)
        .title;
  }

  Future<void> _triggerFeedback() async {
    if (_hapticsEnabled) {
      unawaited(_triggerHaptics());
    }
    if (_soundEnabled) {
      unawaited(_playTapSound());
    }
  }

  Future<void> _triggerHaptics() async {
    try {
      if (!kIsWeb && await Vibration.hasVibrator() == true) {
        await Vibration.vibrate(duration: 22, amplitude: 96);
        return;
      }
    } catch (_) {}

    await HapticFeedback.selectionClick();
  }

  Future<void> _playTapSound() async {
    try {
      if (kIsWeb) {
        await SystemSound.play(SystemSoundType.click);
        return;
      }

      final player = _feedbackPlayer ??= AudioPlayer();
      await player.setReleaseMode(ReleaseMode.stop);
      await player.play(
        AssetSource('audio/tap.wav'),
        mode: PlayerMode.lowLatency,
        volume: 0.65,
      );
    } catch (_) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  void _archiveCurrentSession({required bool goalReached}) {
    if (_currentCount == 0) {
      return;
    }

    final completedAt = DateTime.now();
    final startedAt = _currentSessionStartedAt ?? completedAt;

    _sessions = [
      SessionRecord(
        dhikrId: _currentDhikrId,
        count: _currentCount,
        completedAt: completedAt,
        duration: completedAt.difference(startedAt),
        goalReached: goalReached,
      ),
      ..._sessions,
    ];
  }

  int _countForDay(DateTime day) {
    final normalized = _dateOnly(day);
    final saved = _sessions
        .where((item) => _dateOnly(item.completedAt) == normalized)
        .fold<int>(0, (sum, item) => sum + item.count);

    if (normalized == _dateOnly(DateTime.now()) && !_currentSessionCompleted) {
      return saved + _currentCount;
    }

    return saved;
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  void _touch() {
    notifyListeners();
    unawaited(_persist());
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode({
        'customDhikrs': _customDhikrs.map((item) => item.toJson()).toList(),
        'sessions': _sessions.map((item) => item.toJson()).toList(),
        'currentDhikrId': _currentDhikrId,
        'currentCount': _currentCount,
        'goalPreset': _goalPreset,
        'currentSessionCompleted': _currentSessionCompleted,
        'soundEnabled': _soundEnabled,
        'hapticsEnabled': _hapticsEnabled,
        'darkModeEnabled': _darkModeEnabled,
        'textScale': _textScale,
        'language': _language.name,
        'palette': _palette.name,
        'currentSessionStartedAt': _currentSessionStartedAt
            ?.toUtc()
            .toIso8601String(),
      }),
    );
  }

  @override
  void dispose() {
    unawaited(_feedbackPlayer?.dispose() ?? Future<void>.value());
    super.dispose();
  }
}

class AppScope extends InheritedNotifier<TasbihAppState> {
  const AppScope({
    super.key,
    required TasbihAppState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static TasbihAppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!.notifier!;
  }
}

class DhikrDefinition {
  const DhikrDefinition({
    required this.id,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.category,
    required this.suggestedTarget,
  });

  final String id;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String category;
  final int suggestedTarget;

  bool get isCustom => false;
}

class CustomDhikr extends DhikrDefinition {
  const CustomDhikr({
    required super.id,
    required super.title,
    required super.arabic,
    required super.transliteration,
    required super.translation,
    required super.category,
    required super.suggestedTarget,
  });

  factory CustomDhikr.fromJson(Map<String, dynamic> json) {
    return CustomDhikr(
      id: json['id'] as String,
      title: json['title'] as String,
      arabic: json['arabic'] as String,
      transliteration:
          json['transliteration'] as String? ?? json['title'] as String,
      translation: json['translation'] as String? ?? 'Custom dhikr',
      category: json['category'] as String? ?? 'Custom',
      suggestedTarget: json['suggestedTarget'] as int? ?? 33,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabic': arabic,
      'transliteration': transliteration,
      'translation': translation,
      'category': category,
      'suggestedTarget': suggestedTarget,
    };
  }

  @override
  bool get isCustom => true;
}

class SessionRecord {
  const SessionRecord({
    required this.dhikrId,
    required this.count,
    required this.completedAt,
    required this.duration,
    required this.goalReached,
  });

  factory SessionRecord.fromJson(Map<String, dynamic> json) {
    return SessionRecord(
      dhikrId: json['dhikrId'] as String,
      count: json['count'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String).toLocal(),
      duration: Duration(seconds: json['durationSeconds'] as int? ?? 0),
      goalReached: json['goalReached'] as bool? ?? true,
    );
  }

  final String dhikrId;
  final int count;
  final DateTime completedAt;
  final Duration duration;
  final bool goalReached;

  Map<String, dynamic> toJson() {
    return {
      'dhikrId': dhikrId,
      'count': count,
      'completedAt': completedAt.toUtc().toIso8601String(),
      'durationSeconds': duration.inSeconds,
      'goalReached': goalReached,
    };
  }
}

class DailyCount {
  const DailyCount({required this.day, required this.count});

  final DateTime day;
  final int count;
}
