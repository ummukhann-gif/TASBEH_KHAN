import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class LiquidCounterButton extends StatefulWidget {
  const LiquidCounterButton({
    super.key,
    required this.onTap,
    required this.expanded,
    required this.size,
  });

  final VoidCallback onTap;
  final bool expanded;
  final double size;

  @override
  State<LiquidCounterButton> createState() => _LiquidCounterButtonState();
}

class _LiquidCounterButtonState extends State<LiquidCounterButton> {
  final math.Random _random = math.Random();
  BorderRadius _radius = BorderRadius.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _radius = _generateRadius();
    _timer = Timer.periodic(const Duration(milliseconds: 1700), (_) {
      if (!mounted || widget.expanded) {
        return;
      }
      setState(() => _radius = _generateRadius());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  BorderRadius _generateRadius() {
    double r() => (_random.nextInt(42) + 28).toDouble();

    return BorderRadius.only(
      topLeft: Radius.elliptical(r(), r()),
      topRight: Radius.elliptical(100 - r(), r()),
      bottomRight: Radius.elliptical(100 - r(), 100 - r()),
      bottomLeft: Radius.elliptical(r(), 100 - r()),
    );
  }

  BorderRadius _scaledRadius(double width, double height) {
    if (widget.expanded) {
      return BorderRadius.circular(30);
    }

    Radius scale(Radius source) =>
        Radius.elliptical(source.x / 100 * width, source.y / 100 * height);

    return BorderRadius.only(
      topLeft: scale(_radius.topLeft),
      topRight: scale(_radius.topRight),
      bottomRight: scale(_radius.bottomRight),
      bottomLeft: scale(_radius.bottomLeft),
    );
  }

  void _splashShape() {
    if (widget.expanded) {
      return;
    }

    var count = 0;
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _radius = _generateRadius());
      count += 1;
      if (count >= 3) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scheme = Theme.of(context).colorScheme;
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : widget.size;
        final width = widget.expanded ? availableWidth : widget.size;
        final height = widget.expanded ? 106.0 : widget.size;
        final borderRadius = _scaledRadius(width, height);
        final compact = !widget.expanded && height < 110;
        final collapsedIconSize = compact ? height * 0.28 : 58.0;
        final collapsedGap = compact ? height * 0.06 : 12.0;
        final collapsedLabelStyle = Theme.of(context).textTheme.labelMedium
            ?.copyWith(
              color: scheme.onPrimary.withValues(alpha: 0.86),
              letterSpacing: compact ? 1.6 : 2.4,
              fontWeight: FontWeight.w800,
              fontSize: compact ? 8.0 : null,
            );

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 1, end: widget.expanded ? 0.98 : 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: GestureDetector(
            onTapDown: (_) => _splashShape(),
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 560),
              curve: Curves.easeOutCubic,
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scheme.primary.withValues(alpha: 0.92),
                    scheme.primary.withValues(alpha: 0.82),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.24),
                    blurRadius: 28,
                    spreadRadius: 2,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 560),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      border: Border.all(
                        color: scheme.onPrimary.withValues(alpha: 0.18),
                        width: 1.8,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: borderRadius,
                      onTap: widget.onTap,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 420),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        child: widget.expanded
                            ? Row(
                                key: const ValueKey('expanded'),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Symbols.fingerprint,
                                    fill: 1,
                                    color: scheme.onPrimary,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'TAP',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: scheme.onPrimary,
                                          letterSpacing: 2.6,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ],
                              )
                            : Column(
                                key: const ValueKey('default'),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Symbols.fingerprint,
                                    fill: 1,
                                    color: scheme.onPrimary,
                                    size: collapsedIconSize,
                                  ),
                                  SizedBox(height: collapsedGap),
                                  Text('TAP', style: collapsedLabelStyle),
                                ],
                              ),
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
