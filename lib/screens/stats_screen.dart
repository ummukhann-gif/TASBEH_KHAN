import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_state.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({
    super.key,
    required this.onOpenCounter,
    required this.onOpenDhikr,
  });

  final VoidCallback onOpenCounter;
  final VoidCallback onOpenDhikr;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            Text(
              'Your consistency, focus, and completed sessions',
              style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final contentWidth = math.min(width, 760.0);
            final statColumns = width >= 700 ? 4 : width >= 520 ? 2 : 1;
            final statAspectRatio = switch (statColumns) {
              1 => 3.0,
              2 => width < 620 ? 1.24 : 1.42,
              _ => width < 920 ? 1.04 : 1.20,
            };

            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: contentWidth,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 128),
                  children: [
                    _HeroStatsCard(app: app),
                    const SizedBox(height: 18),
                    GridView.count(
                      crossAxisCount: statColumns,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: statAspectRatio,
                      children: [
                        _StatTile(
                          label: 'Today',
                          value: '${app.todayCount}',
                          caption: 'counts completed',
                          icon: Symbols.today,
                        ),
                        _StatTile(
                          label: 'Sessions',
                          value: '${app.completedSessions}',
                          caption: 'completed rounds',
                          icon: Symbols.task_alt,
                        ),
                        _StatTile(
                          label: 'Streak',
                          value: '${app.activeStreak}',
                          caption: app.activeStreak == 1 ? 'active day' : 'active days',
                          icon: Symbols.local_fire_department,
                        ),
                        _StatTile(
                          label: 'Focus',
                          value: _formatDuration(app.focusTime),
                          caption: 'tracked time',
                          icon: Symbols.timer,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _WeeklyChartCard(app: app),
                    const SizedBox(height: 18),
                    Text(
                      'Recent sessions',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    if (app.recentSessions.isEmpty)
                      _EmptyStatsState(
                        onOpenCounter: onOpenCounter,
                        onOpenDhikr: onOpenDhikr,
                      )
                    else
                      ...app.recentSessions.map((session) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _SessionTile(
                            title: app.labelForDhikr(session.dhikrId),
                            subtitle: _formatSessionDate(session.completedAt),
                            count: session.count,
                            duration: _formatDuration(session.duration),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes >= 60) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return minutes == 0 ? '${hours}h' : '${hours}h ${minutes}m';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    }
    return '${duration.inSeconds}s';
  }

  String _formatSessionDate(DateTime value) {
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final suffix = value.hour >= 12 ? 'PM' : 'AM';
    return '${value.day}/${value.month}/${value.year} • $hour:$minute $suffix';
  }
}

class _HeroStatsCard extends StatelessWidget {
  const _HeroStatsCard({required this.app});

  final TasbihAppState app;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.18),
            scheme.tertiary.withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total dhikr',
            style: theme.textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${app.totalCount}',
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Best session: ${app.bestSessionCount} reps • Current streak: ${app.activeStreak} day${app.activeStreak == 1 ? '' : 's'}',
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
  });

  final String label;
  final String value;
  final String caption;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyChartCard extends StatelessWidget {
  const _WeeklyChartCard({required this.app});

  final TasbihAppState app;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final highest = app.weeklyCounts.fold<int>(0, (maxValue, item) => math.max(maxValue, item.count));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly rhythm',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Counts completed over the last 7 days',
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: app.weeklyCounts.map((item) {
                final isToday = _isToday(item.day);
                final ratio = highest == 0 ? 0.12 : (item.count / highest).clamp(0.12, 1.0);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${item.count}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isToday ? scheme.primary : scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                              height: 170 * ratio,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    isToday ? scheme.primary : scheme.primary.withValues(alpha: 0.34),
                                    isToday
                                        ? scheme.tertiary.withValues(alpha: 0.82)
                                        : scheme.primary.withValues(alpha: 0.12),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _weekdayLabel(item.day.weekday),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isToday ? scheme.primary : scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  String _weekdayLabel(int weekday) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return labels[weekday - 1];
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.duration,
  });

  final String title;
  final String subtitle;
  final int count;
  final String duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Symbols.history, color: scheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  '$subtitle • $duration',
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            'x$count',
            style: theme.textTheme.titleLarge?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyStatsState extends StatelessWidget {
  const _EmptyStatsState({
    required this.onOpenCounter,
    required this.onOpenDhikr,
  });

  final VoidCallback onOpenCounter;
  final VoidCallback onOpenDhikr;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Icon(Symbols.insights, size: 56, color: scheme.primary),
          const SizedBox(height: 14),
          Text(
            'No completed sessions yet',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Pick a dhikr and finish one round to start building useful stats.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onOpenDhikr,
                  child: const Text('Choose dhikr'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onOpenCounter,
                  child: const Text('Start now'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
