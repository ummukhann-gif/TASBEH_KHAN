import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_state.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({
    super.key,
    required this.onOpenCounter,
    required this.onOpenDhikr,
  });

  final VoidCallback onOpenCounter;
  final VoidCallback onOpenDhikr;

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final strings = app.strings;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final minutes = app.totalDuration.inMinutes;
    final sessions = _showAll ? app.sessions : app.sessions.take(5).toList();

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
            children: [
              Text(
                strings.appTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              _HeroStats(app: app),
              const SizedBox(height: 20),
              _WeeklyProgressCard(app: app),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      strings.pastSessions,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: app.sessions.length <= 5
                        ? null
                        : () => setState(() => _showAll = !_showAll),
                    child: Text(strings.viewAll),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (sessions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(strings.noSessionsYet),
                )
              else
                for (final session in sessions) ...[
                  _SessionTile(
                    title: app.labelForDhikr(session.dhikrId),
                    subtitle: _relativeSessionDate(app, session.completedAt),
                    count: session.count,
                    duration: session.duration,
                    completed: session.goalReached,
                    statusLabel: session.goalReached
                        ? strings.completed
                        : strings.saved,
                  ),
                  const SizedBox(height: 12),
                ],
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.06),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.buildHabit,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            strings.buildHabitBody,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${app.totalCount} ${strings.totalDhikr.toLowerCase()} • $minutes ${strings.minutes}',
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Icon(
                      Symbols.nature,
                      size: 72,
                      weight: 200,
                      color: scheme.primary.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _relativeSessionDate(TasbihAppState app, DateTime value) {
    final strings = app.strings;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(value.year, value.month, value.day);

    final label = switch (date) {
      final d when d == today => strings.today,
      final d when d == yesterday => strings.yesterday,
      _ => '${_monthName(value.month)} ${value.day}',
    };

    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final meridiem = value.hour >= 12 ? 'PM' : 'AM';
    return strings.relativeDate(label, '$hour:$minute $meridiem');
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

class _HeroStats extends StatelessWidget {
  const _HeroStats({required this.app});

  final TasbihAppState app;

  @override
  Widget build(BuildContext context) {
    final strings = app.strings;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hours = (app.totalDuration.inMinutes / 60).toStringAsFixed(1);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: scheme.primaryContainer.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: scheme.primary.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.totalDhikr.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.primary,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${app.totalCount}',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Symbols.trending_up,
                    fill: 1,
                    size: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    strings.weekChangeText(math.max(app.weekChangePercent, 0)),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MiniStatCard(
                title: strings.currentStreak,
                value: '${app.activeStreak}',
                suffix: strings.days,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _MiniStatCard(
                title: strings.timeSpent,
                value: hours,
                suffix: strings.hours,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.suffix,
  });

  final String title;
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.tertiary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(suffix, style: theme.textTheme.bodySmall),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyProgressCard extends StatelessWidget {
  const _WeeklyProgressCard({required this.app});

  final TasbihAppState app;

  @override
  Widget build(BuildContext context) {
    final strings = app.strings;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final values = app.weeklyCounts;
    final maxCount = values.fold<int>(
      0,
      (max, item) => math.max(max, item.count),
    );
    final safeMax = math.max(maxCount, 1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.weeklyProgress,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strings.dailyDhikrCount,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  strings.last7Days.toUpperCase(),
                  style: theme.textTheme.labelSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < values.length; i++) ...[
                  Expanded(
                    child: _AnimatedBar(
                      label: _weekLabel(values[i].day.weekday),
                      count: values[i].count,
                      ratio: values[i].count / safeMax,
                      highlighted: i == values.length - 3,
                    ),
                  ),
                  if (i != values.length - 1) const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _weekLabel(int weekday) {
    const map = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return map[weekday - 1];
  }
}

class _AnimatedBar extends StatelessWidget {
  const _AnimatedBar({
    required this.label,
    required this.count,
    required this.ratio,
    required this.highlighted,
  });

  final String label;
  final int count;
  final double ratio;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final clamped = ratio.clamp(0.12, 1.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$count',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: highlighted ? scheme.primary : scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: clamped),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return Container(
                  height: 150 * value,
                  decoration: BoxDecoration(
                    color: highlighted
                        ? scheme.primary
                        : scheme.primary.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    boxShadow: highlighted
                        ? [
                            BoxShadow(
                              color: scheme.primary.withValues(alpha: 0.28),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: highlighted ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: highlighted ? FontWeight.w900 : FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.duration,
    required this.completed,
    required this.statusLabel,
  });

  final String title;
  final String subtitle;
  final int count;
  final Duration duration;
  final bool completed;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'x $count',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Symbols.schedule,
                    size: 12,
                    weight: 700,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$minutes:$seconds min',
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                statusLabel.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: completed ? scheme.primary : scheme.onSurfaceVariant,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
