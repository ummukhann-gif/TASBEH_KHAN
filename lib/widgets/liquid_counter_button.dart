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

class _LiquidCounterButtonState extends State<LiquidCounterButton>
    with SingleTickerProviderStateMixin {
  final math.Random _random = math.Random();
  late final AnimationController _morphController;
  BorderRadius _splashRadius = BorderRadius.zero;
  BorderRadius _settleRadius = BorderRadius.zero;

  @override
  void initState() {
    super.initState();
    _splashRadius = _generateRadius();
    _settleRadius = _generateRadius();
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 680),
    )..addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(covariant LiquidCounterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded && !oldWidget.expanded) {
      _morphController.reset();
    }
  }

  @override
  void dispose() {
    _morphController.dispose();
    super.dispose();
  }

  BorderRadius _generateRadius() {
    return BorderRadius.only(
      topLeft: Radius.elliptical(
        (_random.nextInt(52) + 26).toDouble(),
        (_random.nextInt(44) + 22).toDouble(),
      ),
      topRight: Radius.elliptical(
        (_random.nextInt(58) + 20).toDouble(),
        (_random.nextInt(48) + 20).toDouble(),
      ),
      bottomRight: Radius.elliptical(
        (_random.nextInt(50) + 24).toDouble(),
        (_random.nextInt(54) + 18).toDouble(),
      ),
      bottomLeft: Radius.elliptical(
        (_random.nextInt(54) + 22).toDouble(),
        (_random.nextInt(50) + 20).toDouble(),
      ),
    );
  }

  BorderRadius _scaleBorderRadius(
    BorderRadius source,
    double width,
    double height,
  ) {
    Radius scale(Radius radius) =>
        Radius.elliptical(radius.x / 100 * width, radius.y / 100 * height);

    return BorderRadius.only(
      topLeft: scale(source.topLeft),
      topRight: scale(source.topRight),
      bottomRight: scale(source.bottomRight),
      bottomLeft: scale(source.bottomLeft),
    );
  }

  BorderRadius _scaledRadius(double width, double height) {
    if (widget.expanded) {
      return BorderRadius.circular(30);
    }

    final baseRadius = BorderRadius.circular(math.min(width, height) * 0.5);
    final splash = _scaleBorderRadius(_splashRadius, width, height);
    final settle = _scaleBorderRadius(_settleRadius, width, height);

    final t = _morphController.value;
    if (t == 0) {
      return baseRadius;
    }

    if (t <= 0.34) {
      final phase = Curves.easeOutQuart.transform(t / 0.34);
      return BorderRadius.lerp(baseRadius, splash, phase)!;
    }

    if (t <= 0.64) {
      final phase = Curves.easeInOutCubicEmphasized.transform(
        (t - 0.34) / 0.30,
      );
      return BorderRadius.lerp(splash, settle, phase)!;
    }

    final phase = Curves.easeOutBack.transform((t - 0.64) / 0.36);
    return BorderRadius.lerp(settle, baseRadius, phase)!;
  }

  void _splashShape() {
    if (widget.expanded) {
      return;
    }

    setState(() {
      _splashRadius = _generateRadius();
      _settleRadius = _generateRadius();
    });
    _morphController.forward(from: 0);
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
        final tapScale = widget.expanded
            ? 0.98
            : (1 - _morphController.value * 0.068);
        final innerMargin = widget.expanded
            ? 12.0
            : 12.0 + (1 - Curves.easeOut.transform(_morphController.value)) * 6;
        final collapsedLabelStyle = Theme.of(context).textTheme.labelMedium
            ?.copyWith(
              color: scheme.onPrimary.withValues(alpha: 0.86),
              letterSpacing: compact ? 1.6 : 2.4,
              fontWeight: FontWeight.w800,
              fontSize: compact ? 8.0 : null,
            );

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 1, end: tapScale),
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
                    duration: const Duration(milliseconds: 680),
                    curve: Curves.easeOutQuart,
                    margin: EdgeInsets.all(innerMargin),
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
