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
    final bottomNavClearance =
        72.0 + MediaQuery.viewPaddingOf(context).bottom.clamp(0.0, 12.0);

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
            final height = constraints.maxHeight;
            const collapsedCardHeight = 88.0;
            final expandedCardHeight = (height * 0.42).clamp(220.0, 340.0);

            return Center(
              child: SizedBox(
                width: width,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 4, 20, bottomNavClearance),
                  child: Column(
                    children: [
                      Text(
                        strings.appTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _CurrentDhikrCard(
                        app: app,
                        strings: strings,
                        expanded: _expanded,
                        collapsedHeight: collapsedCardHeight,
                        expandedHeight: expandedCardHeight.toDouble(),
                        onToggle: () => setState(() => _expanded = !_expanded),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, bodyConstraints) {
                            final dense = bodyConstraints.maxHeight < 360;
                            final superDense = bodyConstraints.maxHeight < 300;
                            final compactStatus = dense || _expanded;
                            final showStatus = !superDense;
                            final statusHeight = showStatus
                                ? (compactStatus ? 40.0 : 50.0)
                                : 0.0;
                            final actionsHeight = superDense
                                ? 62.0
                                : (dense ? 68.0 : 82.0);
                            final statusGap = compactStatus ? 6.0 : 12.0;
                            final controlsTopGap = compactStatus ? 8.0 : 14.0;
                            final bottomBlockHeight =
                                controlsTopGap +
                                actionsHeight +
                                (showStatus ? statusGap + statusHeight : 0.0);
                            final heroRegionHeight =
                                bodyConstraints.maxHeight - bottomBlockHeight;

                            return Column(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: _expanded ? 0 : (dense ? 0 : 4),
                                      ),
                                      child: SizedBox(
                                        height: math.max(
                                          heroRegionHeight,
                                          118.0,
                                        ),
                                        child: _CounterHero(
                                          app: app,
                                          strings: strings,
                                          expanded: _expanded,
                                          availableHeight: math.max(
                                            heroRegionHeight,
                                            118.0,
                                          ),
                                          onTap: _increment,
                                          onTargetTap: () =>
                                              _showTargetSheet(context, app),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: controlsTopGap),
                                SizedBox(
                                  height: actionsHeight,
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: _CounterActions(
                                        app: app,
                                        strings: strings,
                                        dense: compactStatus,
                                      ),
                                    ),
                                  ),
                                ),
                                ClipRect(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 420),
                                    curve: Curves.easeOutCubic,
                                    height: showStatus
                                        ? statusHeight + statusGap
                                        : 0,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: statusGap,
                                        ),
                                        child: SizedBox(
                                          height: statusHeight,
                                          child: _TodayStatusPill(
                                            app: app,
                                            strings: strings,
                                            dense: compactStatus,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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
    required this.collapsedHeight,
    required this.expandedHeight,
    required this.onToggle,
  });

  final TasbihAppState app;
  final AppStrings strings;
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
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
      height: expanded ? expandedHeight : collapsedHeight,
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
          if (expanded) ...[
            Divider(color: scheme.primary.withValues(alpha: 0.1), height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                child: Column(
                  children: [
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
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: scheme.primary,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            app.currentDhikr.transliteration,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.primary.withValues(alpha: 0.85),
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
                      if (item != quickItems.last) const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
          ],
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 320;

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
              child: compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            dhikr.arabic,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.rtl,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          dhikr.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dhikr.translation,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    )
                  : Row(
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
                              Text(
                                dhikr.translation,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            dhikr.arabic,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.rtl,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _CounterHero extends StatelessWidget {
  const _CounterHero({
    required this.app,
    required this.strings,
    required this.expanded,
    required this.availableHeight,
    required this.onTap,
    required this.onTargetTap,
  });

  final TasbihAppState app;
  final AppStrings strings;
  final bool expanded;
  final double availableHeight;
  final VoidCallback onTap;
  final VoidCallback onTargetTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final ultraCompactHero = availableHeight < 130;
        final compactHero = availableHeight < 190;
        final smallViewportHero =
            !expanded && (availableHeight < 280 || width < 360);
        final topGap = ultraCompactHero
            ? 0.0
            : compactHero
            ? 2.0
            : smallViewportHero
            ? 4.0
            : (expanded ? 6.0 : 8.0);
        final buttonGap = ultraCompactHero
            ? 4.0
            : compactHero
            ? 6.0
            : smallViewportHero
            ? 10.0
            : (expanded ? 14.0 : 18.0);
        final numberHeight = expanded
            ? math.min(availableHeight * 0.18, 54.0)
            : ultraCompactHero
            ? math.min(availableHeight * 0.12, 28.0)
            : compactHero
            ? math.min(availableHeight * 0.15, 38.0)
            : smallViewportHero
            ? math.min(availableHeight * 0.14, 34.0)
            : math.min(availableHeight * 0.2, 82.0);
        final targetHeight = ultraCompactHero
            ? 22.0
            : compactHero
            ? 28.0
            : smallViewportHero
            ? 26.0
            : 34.0;
        final maxButtonByHeight = math.max(
          availableHeight -
              numberHeight -
              targetHeight -
              topGap -
              buttonGap -
              (ultraCompactHero ? 0 : (smallViewportHero ? 2 : 6)),
          ultraCompactHero ? 42.0 : 64.0,
        );
        final idealButtonSize = expanded
            ? math.min(width, math.max(availableHeight * 0.38, 92.0))
            : ultraCompactHero
            ? math.min(
                math.max(math.min(width * 0.5, 148.0), 96.0),
                math.min(availableHeight * 0.62, 132.0),
              )
            : compactHero
            ? math.min(math.max(availableHeight * 0.4, 88.0), 132.0)
            : smallViewportHero
            ? math.min(
                math.max(math.min(width * 0.58, 188.0), 148.0),
                math.min(availableHeight * 0.74, 188.0),
              )
            : math.min(width * 0.8, math.min(availableHeight * 0.64, 264.0));
        final buttonSize = math.min(idealButtonSize, maxButtonByHeight);
        final ringSize = expanded
            ? buttonSize
            : ultraCompactHero
            ? math.min(
                buttonSize * 1.08,
                math.min(availableHeight * 0.74, width * 0.62),
              )
            : smallViewportHero
            ? math.min(
                buttonSize * 1.18,
                math.min(availableHeight * 0.9, width * 0.78),
              )
            : math.min(
                buttonSize * 1.32,
                math.min(availableHeight * 0.96, width * 0.9),
              );
        final numberStyle =
            (expanded
                    ? theme.textTheme.displaySmall
                    : theme.textTheme.displayMedium)
                ?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: numberHeight,
                );

        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 400),
                          opacity: expanded ? 0 : 0.42,
                          child: _RingBackdrop(
                            progress: app.progress,
                            size: ringSize.clamp(82.0, 340.0).toDouble(),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 420),
                              curve: Curves.easeOutCubic,
                              style: numberStyle ?? const TextStyle(),
                              child: Text('${app.currentCount}'),
                            ),
                            SizedBox(height: topGap),
                            _TargetPill(
                              count: app.currentCount,
                              targetLabel: app.currentTargetLabel,
                              dense:
                                  ultraCompactHero ||
                                  compactHero ||
                                  smallViewportHero,
                              onTap: onTargetTap,
                            ),
                            SizedBox(height: buttonGap),
                            LiquidCounterButton(
                              onTap: onTap,
                              expanded: expanded,
                              size: buttonSize
                                  .clamp(ultraCompactHero ? 42.0 : 64.0, 300.0)
                                  .toDouble(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RingBackdrop extends StatelessWidget {
  const _RingBackdrop({required this.progress, required this.size});

  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return CustomPaint(
          size: Size.square(size),
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
    required this.dense,
    required this.onTap,
  });

  final int count;
  final String targetLabel;
  final bool dense;
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
          padding: EdgeInsets.symmetric(
            horizontal: dense ? 10 : 12,
            vertical: dense ? 5 : 6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Symbols.target,
                size: dense ? 12 : 14,
                fill: 1,
                color: scheme.primary,
              ),
              SizedBox(width: dense ? 4 : 6),
              Text(
                '$count / $targetLabel',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.primary,
                  letterSpacing: dense ? 0.7 : 1.1,
                  fontSize: dense ? 10 : null,
                ),
              ),
              SizedBox(width: dense ? 2 : 4),
              Icon(
                Symbols.expand_more,
                size: dense ? 12 : 14,
                color: scheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CounterActions extends StatelessWidget {
  const _CounterActions({
    required this.app,
    required this.strings,
    required this.dense,
  });

  final TasbihAppState app;
  final AppStrings strings;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionItem(
          icon: Symbols.refresh,
          label: strings.reset,
          active: false,
          dense: dense,
          onTap: app.currentCount == 0 ? null : app.resetCurrentSession,
        ),
        SizedBox(width: dense ? 20 : 26),
        _ActionItem(
          icon: Symbols.volume_up,
          label: strings.sound,
          active: app.soundEnabled,
          dense: dense,
          onTap: () => app.setSoundEnabled(!app.soundEnabled),
        ),
        SizedBox(width: dense ? 20 : 26),
        _ActionItem(
          icon: Symbols.vibration,
          label: strings.haptic,
          active: app.hapticsEnabled,
          dense: dense,
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
    required this.dense,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final bool dense;
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
              width: dense ? 42 : 48,
              height: dense ? 42 : 48,
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
            SizedBox(height: dense ? 6 : 8),
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.secondary.withValues(alpha: 0.78),
                letterSpacing: 0.8,
                fontSize: dense ? 9 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayStatusPill extends StatelessWidget {
  const _TodayStatusPill({
    required this.app,
    required this.strings,
    required this.dense,
  });

  final TasbihAppState app;
  final AppStrings strings;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final target = app.currentTarget;
    final reached = app.isGoalReached;
    final label = target == null
        ? strings.infinityMode
        : reached
        ? strings.goalReachedCompact
        : strings.goalProgressCompact(app.currentCount, '$target');
    final icon = target == null
        ? Symbols.all_inclusive
        : reached
        ? Symbols.task_alt
        : Symbols.flag;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 12 : 14,
        vertical: dense ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.tertiary.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: dense ? 28 : 32,
            height: dense ? 28 : 32,
            decoration: BoxDecoration(
              color: scheme.tertiary.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: dense ? 16 : 18,
              fill: 1,
              color: scheme.tertiary,
            ),
          ),
          SizedBox(width: dense ? 8 : 10),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: dense ? 13 : 14,
                color: reached ? scheme.primary : scheme.onSurface,
              ),
            ),
          ),
          if (target != null)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: dense ? 6 : 10,
                vertical: dense ? 3 : 5,
              ),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: reached ? 0.18 : 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${app.currentCount}/$target',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: dense ? 11 : null,
                ),
              ),
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
