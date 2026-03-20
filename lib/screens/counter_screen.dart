import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_state.dart';
import '../theme.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  bool _isPressed = false;

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
              'Terra Tasbih',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            Text(
              'Mindful dhikr, one focused session at a time',
              style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final compact = width < 380;
            final dialSize = math.min(width * (compact ? 0.78 : 0.72), 320.0);
            final contentWidth = math.min(width, 520.0);

            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: contentWidth,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 128),
                  children: [
                    _CurrentDhikrCard(
                      app: app,
                      onChange: () => _showDhikrPicker(context, app),
                    ),
                    const SizedBox(height: 20),
                    _CounterDial(
                      size: dialSize,
                      progress: app.progress,
                      count: app.currentCount,
                      target: app.currentTarget,
                      isPressed: _isPressed,
                      onTap: () => _handleCountTap(app),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _ActionChipButton(
                          icon: Symbols.undo,
                          label: 'Undo',
                          onTap: app.currentCount == 0 ? null : app.undoCount,
                        ),
                        _ActionChipButton(
                          icon: Symbols.restart_alt,
                          label: 'Reset',
                          onTap: app.currentCount == 0 ? null : app.resetCurrentSession,
                        ),
                        _ActionChipButton(
                          icon: app.soundEnabled ? Symbols.volume_up : Symbols.volume_off,
                          label: app.soundEnabled ? 'Sound On' : 'Sound Off',
                          onTap: () => app.setSoundEnabled(!app.soundEnabled),
                          highlighted: app.soundEnabled,
                        ),
                        _ActionChipButton(
                          icon: app.hapticsEnabled ? Symbols.vibration : Symbols.block,
                          label: app.hapticsEnabled ? 'Haptics On' : 'Haptics Off',
                          onTap: () => app.setHapticsEnabled(!app.hapticsEnabled),
                          highlighted: app.hapticsEnabled,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _InsightCard(app: app),
                    const SizedBox(height: 20),
                    if (app.recentSessions.isNotEmpty) ...[
                      Text(
                        'Recent sessions',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 12),
                      ...app.recentSessions.take(3).map((session) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _RecentSessionTile(
                            title: app.labelForDhikr(session.dhikrId),
                            subtitle: _formatSessionTime(session.completedAt),
                            count: session.count,
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleCountTap(TasbihAppState app) async {
    final wasReached = app.isGoalReached;
    setState(() => _isPressed = true);
    await app.incrementCount();
    if (mounted) {
      Future<void>.delayed(const Duration(milliseconds: 140), () {
        if (mounted) {
          setState(() => _isPressed = false);
        }
      });
    }

    if (!wasReached && app.isGoalReached && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${app.currentDhikr.title} completed at ${app.currentTarget} counts.'),
        ),
      );
    }
  }

  Future<void> _showDhikrPicker(BuildContext context, TasbihAppState app) async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) {
        final theme = Theme.of(context);
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          itemCount: app.allDhikrs.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final dhikr = app.allDhikrs[index];
            final selected = dhikr.id == app.currentDhikr.id;
            return Material(
              color: selected
                  ? theme.colorScheme.primary.withValues(alpha: 0.12)
                  : theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                  foregroundColor: theme.colorScheme.primary,
                  child: Icon(dhikr.icon),
                ),
                title: Text(dhikr.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                subtitle: Text(
                  '${dhikr.category} • ${dhikr.suggestedTarget} reps',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                trailing: selected ? Icon(Symbols.check_circle, color: theme.colorScheme.primary, fill: 1) : null,
                onTap: () {
                  app.selectDhikr(dhikr.id);
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );
      },
    );
  }

  String _formatSessionTime(DateTime value) {
    final now = DateTime.now();
    final day = DateTime(value.year, value.month, value.day);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final prefix = switch (day) {
      final d when d == today => 'Today',
      final d when d == yesterday => 'Yesterday',
      _ => '${value.day}/${value.month}/${value.year}',
    };

    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final suffix = value.hour >= 12 ? 'PM' : 'AM';
    return '$prefix • $hour:$minute $suffix';
  }
}

class _CurrentDhikrCard extends StatelessWidget {
  const _CurrentDhikrCard({
    required this.app,
    required this.onChange,
  });

  final TasbihAppState app;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.14),
            scheme.tertiary.withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(app.currentDhikr.icon, color: scheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current dhikr',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                    Text(
                      app.currentDhikr.title,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: onChange,
                icon: const Icon(Symbols.swap_horiz),
                label: const Text('Change'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            app.currentDhikr.arabic,
            textDirection: TextDirection.rtl,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            app.currentDhikr.translation,
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoPill(icon: Symbols.target, label: 'Goal ${app.currentTarget}'),
              _InfoPill(icon: Symbols.local_fire_department, label: '${app.activeStreak} day streak'),
              _InfoPill(icon: Symbols.today, label: '${app.todayCount} today'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CounterDial extends StatelessWidget {
  const _CounterDial({
    required this.size,
    required this.progress,
    required this.count,
    required this.target,
    required this.isPressed,
    required this.onTap,
  });

  final double size;
  final double progress;
  final int count;
  final int target;
  final bool isPressed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final innerSize = size * 0.74;

    return SizedBox(
      height: size + 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 480),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 14,
                  backgroundColor: scheme.primary.withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                );
              },
            ),
          ),
          AnimatedScale(
            scale: isPressed ? 0.965 : 1,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: innerSize,
                height: innerSize,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      scheme.primary,
                      AppTheme.primaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(innerSize * 0.26),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.26),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(innerSize * 0.26),
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Symbols.touch_app, color: scheme.onPrimary, size: innerSize * 0.18, fill: 1),
                          const SizedBox(height: 12),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(scale: animation, child: child);
                            },
                            child: Text(
                              '$count',
                              key: ValueKey(count),
                              style: theme.textTheme.displayLarge?.copyWith(
                                color: scheme.onPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: innerSize * 0.22,
                                height: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to count',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: scheme.onPrimary.withValues(alpha: 0.84),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$count / $target',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onPrimary.withValues(alpha: 0.78),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.app});

  final TasbihAppState app;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final message = app.isGoalReached
        ? 'Session completed. Your progress has been saved to stats.'
        : app.currentCount == 0
            ? 'Start tapping to begin a focused session.'
            : '${app.currentTarget - app.currentCount} counts left to complete this round.';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: scheme.tertiary.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              app.isGoalReached ? Symbols.task_alt : Symbols.insights,
              color: scheme.tertiary,
              fill: 1,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.isGoalReached ? 'Goal reached' : 'Session insight',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentSessionTile extends StatelessWidget {
  const _RecentSessionTile({
    required this.title,
    required this.subtitle,
    required this.count,
  });

  final String title;
  final String subtitle;
  final int count;

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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Symbols.history, color: scheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                Text(
                  subtitle,
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

class _ActionChipButton extends StatelessWidget {
  const _ActionChipButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: highlighted
              ? scheme.primary.withValues(alpha: 0.12)
              : scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: (highlighted ? scheme.primary : scheme.outlineVariant).withValues(alpha: 0.22),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: highlighted ? scheme.primary : scheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: onTap == null ? scheme.onSurfaceVariant.withValues(alpha: 0.5) : null,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
