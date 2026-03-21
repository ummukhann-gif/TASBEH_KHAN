import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_state.dart';
import '../app_strings.dart';
import '../widgets/liquid_counter_button.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final strings = app.strings;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.surface, Theme.of(context).scaffoldBackgroundColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = math.min(constraints.maxWidth, 520.0);
            final collapsedSize = math.min(width * 0.68, 288.0);

            return Center(
              child: SizedBox(
                width: width,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 112),
                  children: [
                    Text(
                      strings.appTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _CurrentDhikrCard(
                      app: app,
                      strings: strings,
                      expanded: _expanded,
                      onToggle: () => setState(() => _expanded = !_expanded),
                    ),
                    const SizedBox(height: 18),
                    _CounterHero(
                      app: app,
                      strings: strings,
                      expanded: _expanded,
                      buttonSize: collapsedSize,
                      onTap: _increment,
                      onTargetTap: () => _showTargetSheet(context, app),
                    ),
                    const SizedBox(height: 22),
                    _CounterActions(app: app, strings: strings),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 420),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: _expanded
                          ? const SizedBox.shrink()
                          : _TodayStatusPill(
                              key: const ValueKey('status'),
                              app: app,
                              strings: strings,
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _increment() async {
    final app = AppScope.of(context);
    final alreadyReached = app.currentSessionCompleted;
    await app.incrementCount();

    if (!alreadyReached && app.currentSessionCompleted && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(app.strings.sessionComplete)));
    }
  }

  Future<void> _showTargetSheet(
    BuildContext context,
    TasbihAppState app,
  ) async {
    final strings = app.strings;
    final controller = TextEditingController(
      text: app.goalPreset > 0 ? app.goalPreset.toString() : '',
    );

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.sessionGoal,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _GoalChip(
                    label: strings.defaultGoal,
                    selected: app.goalPreset == 0,
                    onTap: () {
                      app.setGoalPreset(0);
                      Navigator.pop(context);
                    },
                  ),
                  _GoalChip(
                    label: '33',
                    selected: app.goalPreset == 33,
                    onTap: () {
                      app.setGoalPreset(33);
                      Navigator.pop(context);
                    },
                  ),
                  _GoalChip(
                    label: '99',
                    selected: app.goalPreset == 99,
                    onTap: () {
                      app.setGoalPreset(99);
                      Navigator.pop(context);
                    },
                  ),
                  _GoalChip(
                    label: strings.infinity,
                    selected: app.goalPreset == -1,
                    onTap: () {
                      app.setGoalPreset(-1);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: strings.enterCustomTarget,
                  suffixIcon: Icon(
                    Symbols.ads_click,
                    color: scheme.primary.withValues(alpha: 0.55),
                  ),
                ),
                onSubmitted: (_) {
                  final value = int.tryParse(controller.text.trim());
                  if (value != null && value > 0) {
                    app.setGoalPreset(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CurrentDhikrCard extends StatelessWidget {
  const _CurrentDhikrCard({
    required this.app,
    required this.strings,
    required this.expanded,
    required this.onToggle,
  });

  final TasbihAppState app;
  final AppStrings strings;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final quickItems = app.allDhikrs
        .where((item) => item.id != app.currentDhikr.id)
        .take(3)
        .toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.08),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.currentDhikr.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.tertiary,
                            letterSpacing: 1.7,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          app.currentDhikr.transliteration,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Symbols.expand_more, color: scheme.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              child: expanded
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                      child: Column(
                        children: [
                          Divider(
                            color: scheme.primary.withValues(alpha: 0.1),
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: scheme.primary.withValues(alpha: 0.12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  app.currentDhikr.arabic,
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        color: scheme.primary,
                                        height: 1.6,
                                      ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  app.currentDhikr.transliteration,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.primary.withValues(
                                      alpha: 0.85,
                                    ),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  app.currentDhikr.translation,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontStyle: FontStyle.italic,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              strings.quickSelection.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.tertiary,
                                letterSpacing: 1.7,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          for (final item in quickItems) ...[
                            _QuickDhikrTile(
                              dhikr: item,
                              onTap: () => app.selectDhikr(item.id),
                            ),
                            if (item != quickItems.last)
                              const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickDhikrTile extends StatelessWidget {
  const _QuickDhikrTile({required this.dhikr, required this.onTap});

  final DhikrDefinition dhikr;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dhikr.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(dhikr.translation, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                dhikr.arabic,
                textDirection: TextDirection.rtl,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CounterHero extends StatelessWidget {
  const _CounterHero({
    required this.app,
    required this.strings,
    required this.expanded,
    required this.buttonSize,
    required this.onTap,
    required this.onTargetTap,
  });

  final TasbihAppState app;
  final AppStrings strings;
  final bool expanded;
  final double buttonSize;
  final VoidCallback onTap;
  final VoidCallback onTargetTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: expanded ? 0 : 0.42,
                child: _RingBackdrop(progress: app.progress),
              ),
              Column(
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeOutCubic,
                    style:
                        (expanded
                                ? theme.textTheme.displaySmall
                                : theme.textTheme.displayMedium)
                            ?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w800,
                            ) ??
                        const TextStyle(),
                    child: Text('${app.currentCount}'),
                  ),
                  const SizedBox(height: 8),
                  _TargetPill(
                    count: app.currentCount,
                    targetLabel: app.currentTargetLabel,
                    onTap: onTargetTap,
                  ),
                  const SizedBox(height: 22),
                  LiquidCounterButton(
                    onTap: onTap,
                    expanded: expanded,
                    size: buttonSize,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingBackdrop extends StatelessWidget {
  const _RingBackdrop({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return CustomPaint(
          size: const Size(320, 320),
          painter: _RingPainter(
            progress: value,
            activeColor: scheme.primary.withValues(alpha: 0.2),
            baseColor: scheme.primary.withValues(alpha: 0.08),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.activeColor,
    required this.baseColor,
  });

  final double progress;
  final Color activeColor;
  final Color baseColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outer = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = baseColor;
    final inner = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = baseColor.withValues(alpha: 0.55);
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = activeColor;

    canvas.drawCircle(center, size.width * 0.38, outer);
    canvas.drawCircle(center, size.width * 0.33, inner);

    final rect = Rect.fromCircle(center: center, radius: size.width * 0.38);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      progress * math.pi * 2,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.baseColor != baseColor;
  }
}

class _TargetPill extends StatelessWidget {
  const _TargetPill({
    required this.count,
    required this.targetLabel,
    required this.onTap,
  });

  final int count;
  final String targetLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Symbols.target, size: 14, fill: 1, color: scheme.primary),
              const SizedBox(width: 6),
              Text(
                '$count / $targetLabel',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.primary,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Symbols.expand_more, size: 14, color: scheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _CounterActions extends StatelessWidget {
  const _CounterActions({required this.app, required this.strings});

  final TasbihAppState app;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionItem(
          icon: Symbols.refresh,
          label: strings.reset,
          active: false,
          onTap: app.currentCount == 0 ? null : app.resetCurrentSession,
        ),
        const SizedBox(width: 26),
        _ActionItem(
          icon: Symbols.volume_up,
          label: strings.sound,
          active: app.soundEnabled,
          onTap: () => app.setSoundEnabled(!app.soundEnabled),
        ),
        const SizedBox(width: 26),
        _ActionItem(
          icon: Symbols.vibration,
          label: strings.haptic,
          active: app.hapticsEnabled,
          onTap: () => app.setHapticsEnabled(!app.hapticsEnabled),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Opacity(
      opacity: onTap == null ? 0.45 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: active
                    ? scheme.secondary.withValues(alpha: 0.95)
                    : scheme.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: active ? scheme.onSecondary : scheme.secondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.secondary.withValues(alpha: 0.78),
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayStatusPill extends StatelessWidget {
  const _TodayStatusPill({super.key, required this.app, required this.strings});

  final TasbihAppState app;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final minutes = app.todayDuration.inMinutes;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.tertiary.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: scheme.tertiary.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(Symbols.trending_up, fill: 1, color: scheme.tertiary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.todayCount >= (app.currentTarget ?? 33)
                      ? strings.dailyGoalReached
                      : strings.todayFocus,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  strings.sessionSummary(app.todaySessionCount, minutes),
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(letterSpacing: 0.9),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$minutes',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: scheme.primary),
              ),
              Text(
                strings.minutes.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.primary.withValues(alpha: 0.7),
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

class _GoalChip extends StatelessWidget {
  const _GoalChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: selected ? scheme.primary : scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? scheme.onPrimary : scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
