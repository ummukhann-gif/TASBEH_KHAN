import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbihAppState extends ChangeNotifier {
  TasbihAppState._();

  static const String _prefsKey = 'terra_tasbih_state_v2';

  final List<DhikrDefinition> _builtInDhikrs = const [
    DhikrDefinition(
      id: 'subhanallah',
      title: 'SubhanAllah',
      arabic: 'سُبْحَانَ اللهِ',
      translation: 'Glory be to Allah',
      category: 'Morning',
      suggestedTarget: 33,
      icon: Symbols.auto_awesome,
    ),
    DhikrDefinition(
      id: 'alhamdulillah',
      title: 'Alhamdulillah',
      arabic: 'الْحَمْدُ لِلَّهِ',
      translation: 'Praise be to Allah',
      category: 'Essential',
      suggestedTarget: 33,
      icon: Symbols.favorite,
    ),
    DhikrDefinition(
      id: 'allahuakbar',
      title: 'Allahu Akbar',
      arabic: 'اللهُ أَكْبَرُ',
      translation: 'Allah is the Greatest',
      category: 'Greatness',
      suggestedTarget: 34,
      icon: Symbols.filter_vintage,
    ),
    DhikrDefinition(
      id: 'astaghfirullah',
      title: 'Astaghfirullah',
      arabic: 'أَسْتَغْفِرُ اللهَ',
      translation: 'I seek forgiveness from Allah',
      category: 'Istighfar',
      suggestedTarget: 100,
      icon: Symbols.spa,
    ),
  ];

  List<CustomDhikr> _customDhikrs = [];
  List<SessionRecord> _sessions = [];
  String _currentDhikrId = 'subhanallah';
  int _currentCount = 0;
  int _goalPreset = 0;
  bool _hapticsEnabled = true;
  bool _soundEnabled = false;
  bool _darkModeEnabled = false;
  double _intensity = 0.8;
  DateTime? _currentSessionStartedAt;

  static Future<TasbihAppState> load() async {
    final state = TasbihAppState._();
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);

    if (raw == null) {
      return state;
    }

    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      state._customDhikrs = ((data['customDhikrs'] as List<dynamic>? ?? const []))
          .map((item) => CustomDhikr.fromJson(item as Map<String, dynamic>))
          .toList();
      state._sessions = ((data['sessions'] as List<dynamic>? ?? const []))
          .map((item) => SessionRecord.fromJson(item as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
      state._currentDhikrId = data['currentDhikrId'] as String? ?? state._currentDhikrId;
      state._currentCount = data['currentCount'] as int? ?? 0;
      state._goalPreset = data['goalPreset'] as int? ?? 0;
      state._hapticsEnabled = data['hapticsEnabled'] as bool? ?? true;
      state._soundEnabled = data['soundEnabled'] as bool? ?? false;
      state._darkModeEnabled = data['darkModeEnabled'] as bool? ?? false;
      state._intensity = (data['intensity'] as num?)?.toDouble() ?? 0.8;
      final startedAtRaw = data['currentSessionStartedAt'] as String?;
      state._currentSessionStartedAt =
          startedAtRaw == null ? null : DateTime.tryParse(startedAtRaw)?.toLocal();
    } catch (_) {
      return state;
    }

    if (!state.allDhikrs.any((dhikr) => dhikr.id == state._currentDhikrId)) {
      state._currentDhikrId = state._builtInDhikrs.first.id;
      state._currentCount = 0;
      state._currentSessionStartedAt = null;
    }

    return state;
  }

  List<DhikrDefinition> get allDhikrs => [..._builtInDhikrs, ..._customDhikrs];

  DhikrDefinition get currentDhikr =>
      allDhikrs.firstWhere((dhikr) => dhikr.id == _currentDhikrId, orElse: () => _builtInDhikrs.first);

  List<SessionRecord> get sessions => List.unmodifiable(_sessions);
  List<SessionRecord> get recentSessions => List.unmodifiable(_sessions.take(8));
  int get currentCount => _currentCount;
  int get goalPreset => _goalPreset;
  int get currentTarget => _goalPreset == 0 ? currentDhikr.suggestedTarget : _goalPreset;
  bool get hapticsEnabled => _hapticsEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  double get intensity => _intensity;
  bool get isGoalReached => _currentCount >= currentTarget;
  double get progress => currentTarget == 0 ? 0 : (_currentCount / currentTarget).clamp(0, 1).toDouble();
  int get totalCount => _sessions.fold(0, (sum, session) => sum + session.count);
  int get completedSessions => _sessions.length;
  int get bestSessionCount =>
      _sessions.isEmpty ? 0 : _sessions.map((session) => session.count).reduce((a, b) => a > b ? a : b);
  int get todayCount => _countForDay(DateTime.now());
  Duration get focusTime {
    if (_sessions.isEmpty) {
      return Duration.zero;
    }
    final totalSeconds = _sessions.fold<int>(0, (sum, session) => sum + session.duration.inSeconds);
    return Duration(seconds: totalSeconds);
  }

  int get activeStreak {
    if (_sessions.isEmpty) {
      return 0;
    }

    final activeDays = _sessions
        .map((session) => _dateOnly(session.completedAt))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    var cursor = _dateOnly(DateTime.now());
    var streak = 0;

    for (final day in activeDays) {
      if (day == cursor) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      } else if (day.isBefore(cursor)) {
        break;
      }
    }

    return streak;
  }

  List<DailyCount> get weeklyCounts {
    final now = _dateOnly(DateTime.now());
    return List<DailyCount>.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      return DailyCount(day: day, count: _countForDay(day));
    });
  }

  Future<void> incrementCount() async {
    if (isGoalReached) {
      return;
    }

    _currentSessionStartedAt ??= DateTime.now();
    _currentCount += 1;
    notifyListeners();
    _triggerFeedback();

    if (isGoalReached) {
      _completeCurrentSession();
    }

    _persist();
  }

  void undoCount() {
    if (_currentCount == 0) {
      return;
    }
    _currentCount -= 1;
    if (_currentCount == 0) {
      _currentSessionStartedAt = null;
    }
    _touch();
  }

  void resetCurrentSession() {
    _currentCount = 0;
    _currentSessionStartedAt = null;
    _touch();
  }

  void selectDhikr(String dhikrId) {
    if (_currentDhikrId == dhikrId) {
      return;
    }
    _currentDhikrId = dhikrId;
    _currentCount = 0;
    _currentSessionStartedAt = null;
    _touch();
  }

  void setGoalPreset(int target) {
    _goalPreset = target;
    if (_currentCount > currentTarget) {
      _currentCount = currentTarget;
    }
    _touch();
  }

  void setHapticsEnabled(bool value) {
    _hapticsEnabled = value;
    _touch();
  }

  void setSoundEnabled(bool value) {
    _soundEnabled = value;
    _touch();
  }

  void setDarkModeEnabled(bool value) {
    _darkModeEnabled = value;
    _touch();
  }

  void setIntensity(double value) {
    _intensity = value;
    _touch();
  }

  void addCustomDhikr({
    required String title,
    required String arabic,
    required String translation,
    required int target,
  }) {
    final id = '${title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}-${DateTime.now().millisecondsSinceEpoch}';
    _customDhikrs = [
      CustomDhikr(
        id: id,
        title: title.trim(),
        arabic: arabic.trim(),
        translation: translation.trim(),
        category: 'Custom',
        suggestedTarget: target,
      ),
      ..._customDhikrs,
    ];
    _touch();
  }

  void removeCustomDhikr(String id) {
    _customDhikrs.removeWhere((dhikr) => dhikr.id == id);
    _sessions.removeWhere((session) => session.dhikrId == id);
    if (_currentDhikrId == id) {
      _currentDhikrId = _builtInDhikrs.first.id;
      _currentCount = 0;
      _currentSessionStartedAt = null;
    }
    _touch();
  }

  void resetAllProgress() {
    _sessions = [];
    _currentCount = 0;
    _currentDhikrId = _builtInDhikrs.first.id;
    _currentSessionStartedAt = null;
    _goalPreset = 0;
    _touch();
  }

  String labelForDhikr(String id) =>
      allDhikrs.firstWhere((dhikr) => dhikr.id == id, orElse: () => currentDhikr).title;

  Future<void> _triggerFeedback() async {
    if (_hapticsEnabled) {
      if (_intensity >= 0.8) {
        unawaited(HapticFeedback.mediumImpact());
      } else if (_intensity >= 0.45) {
        unawaited(HapticFeedback.lightImpact());
      } else {
        unawaited(HapticFeedback.selectionClick());
      }
    }

    if (_soundEnabled) {
      unawaited(SystemSound.play(SystemSoundType.click));
    }
  }

  void _completeCurrentSession() {
    final completedAt = DateTime.now();
    final startedAt = _currentSessionStartedAt ?? completedAt;
    _sessions = [
      SessionRecord(
        dhikrId: _currentDhikrId,
        count: _currentCount,
        completedAt: completedAt,
        duration: completedAt.difference(startedAt),
      ),
      ..._sessions,
    ];
  }

  int _countForDay(DateTime day) {
    final targetDay = _dateOnly(day);
    return _sessions
        .where((session) => _dateOnly(session.completedAt) == targetDay)
        .fold<int>(0, (sum, session) => sum + session.count);
  }

  DateTime _dateOnly(DateTime value) => DateTime(value.year, value.month, value.day);

  void _touch() {
    notifyListeners();
    _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode({
        'customDhikrs': _customDhikrs.map((dhikr) => dhikr.toJson()).toList(),
        'sessions': _sessions.map((session) => session.toJson()).toList(),
        'currentDhikrId': _currentDhikrId,
        'currentCount': _currentCount,
        'goalPreset': _goalPreset,
        'hapticsEnabled': _hapticsEnabled,
        'soundEnabled': _soundEnabled,
        'darkModeEnabled': _darkModeEnabled,
        'intensity': _intensity,
        'currentSessionStartedAt': _currentSessionStartedAt?.toUtc().toIso8601String(),
      }),
    );
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
    assert(scope != null, 'AppScope not found in widget tree.');
    return scope!.notifier!;
  }
}

class DhikrDefinition {
  const DhikrDefinition({
    required this.id,
    required this.title,
    required this.arabic,
    required this.translation,
    required this.category,
    required this.suggestedTarget,
    required this.icon,
  });

  final String id;
  final String title;
  final String arabic;
  final String translation;
  final String category;
  final int suggestedTarget;
  final IconData icon;

  bool get isCustom => false;
}

class CustomDhikr extends DhikrDefinition {
  const CustomDhikr({
    required super.id,
    required super.title,
    required super.arabic,
    required super.translation,
    required super.category,
    required super.suggestedTarget,
  }) : super(icon: Symbols.stars_2);

  factory CustomDhikr.fromJson(Map<String, dynamic> json) {
    return CustomDhikr(
      id: json['id'] as String,
      title: json['title'] as String,
      arabic: json['arabic'] as String,
      translation: json['translation'] as String,
      category: json['category'] as String? ?? 'Custom',
      suggestedTarget: json['suggestedTarget'] as int? ?? 33,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabic': arabic,
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
  });

  factory SessionRecord.fromJson(Map<String, dynamic> json) {
    return SessionRecord(
      dhikrId: json['dhikrId'] as String,
      count: json['count'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String).toLocal(),
      duration: Duration(seconds: json['durationSeconds'] as int? ?? 0),
    );
  }

  final String dhikrId;
  final int count;
  final DateTime completedAt;
  final Duration duration;

  Map<String, dynamic> toJson() {
    return {
      'dhikrId': dhikrId,
      'count': count,
      'completedAt': completedAt.toUtc().toIso8601String(),
      'durationSeconds': duration.inSeconds,
    };
  }
}

class DailyCount {
  const DailyCount({
    required this.day,
    required this.count,
  });

  final DateTime day;
  final int count;
}
