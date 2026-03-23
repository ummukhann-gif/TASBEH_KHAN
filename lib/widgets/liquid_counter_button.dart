import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

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
  late final AnimationController _controller;
  _LiquidProfile _splashProfile = _LiquidProfile.zero;
  _LiquidProfile _settleProfile = _LiquidProfile.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
  }

  @override
  void didUpdateWidget(covariant LiquidCounterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded && !oldWidget.expanded) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _LiquidProfile _randomProfile() {
    double range(double min, double max) =>
        min + _random.nextDouble() * (max - min);

    return _LiquidProfile(
      top: range(-0.16, 0.48),
      right: range(-0.10, 0.54),
      bottom: range(-0.18, 0.42),
      left: range(-0.10, 0.54),
      leanX: range(-0.45, 0.45),
      leanY: range(-0.24, 0.24),
    );
  }

  _LiquidProfile _profileAt(double t) {
    if (t == 0) {
      return _LiquidProfile.zero;
    }

    if (t <= 0.38) {
      final phase = Curves.easeOutCubic.transform(t / 0.38);
      return _LiquidProfile.lerp(_LiquidProfile.zero, _splashProfile, phase);
    }

    if (t <= 0.72) {
      final phase = Curves.easeInOutCubicEmphasized.transform((t - 0.38) / 0.34);
      return _LiquidProfile.lerp(_splashProfile, _settleProfile, phase);
    }

    final phase = Curves.easeOutQuart.transform((t - 0.72) / 0.28);
    return _LiquidProfile.lerp(_settleProfile, _LiquidProfile.zero, phase);
  }

  void _triggerMorph() {
    if (widget.expanded) {
      return;
    }

    setState(() {
      _splashProfile = _randomProfile();
      _settleProfile = _randomProfile() * 0.42;
    });
    _controller.forward(from: 0);
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
        final collapsedChild = _CollapsedLiquidContent(
          size: Size(width, height),
          scheme: scheme,
        );
        final expandedChild = _ExpandedTapButton(
          width: width,
          height: height,
          scheme: scheme,
        );

        return AnimatedBuilder(
          animation: _controller,
          child: widget.expanded ? expandedChild : collapsedChild,
          builder: (context, child) {
            final morph = _controller.value;
            final scale = widget.expanded ? 0.985 : 1 - morph * 0.038;

            return Semantics(
              button: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) => _triggerMorph(),
                onTap: widget.onTap,
                child: Transform.scale(
                  scale: scale,
                  child: widget.expanded
                      ? child!
                      : _CollapsedLiquidButton(
                          size: Size(width, height),
                          scheme: scheme,
                          profile: _profileAt(morph),
                          child: child!,
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ExpandedTapButton extends StatelessWidget {
  const _ExpandedTapButton({
    required this.width,
    required this.height,
    required this.scheme,
  });

  final double width;
  final double height;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.92),
            scheme.primary.withValues(alpha: 0.82),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.24),
            blurRadius: 28,
            spreadRadius: 2,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.18),
                width: 1.8,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: scheme.onPrimary,
                      letterSpacing: 2.6,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CollapsedLiquidButton extends StatelessWidget {
  const _CollapsedLiquidButton({
    required this.size,
    required this.scheme,
    required this.profile,
    required this.child,
  });

  final Size size;
  final ColorScheme scheme;
  final _LiquidProfile profile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: size,
        painter: _LiquidButtonPainter(
          scheme: scheme,
          profile: profile,
        ),
        child: child,
      ),
    );
  }
}

class _CollapsedLiquidContent extends StatelessWidget {
  const _CollapsedLiquidContent({
    required this.size,
    required this.scheme,
  });

  final Size size;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final compact = size.shortestSide < 110;
    final iconSize = compact ? size.shortestSide * 0.26 : 56.0;
    final textStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: scheme.onPrimary.withValues(alpha: 0.86),
      letterSpacing: compact ? 1.5 : 2.2,
      fontWeight: FontWeight.w800,
      fontSize: compact ? 8.0 : 10.0,
    );

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Symbols.fingerprint,
                  fill: 1,
                  color: scheme.onPrimary,
                  size: iconSize,
                ),
                SizedBox(height: compact ? 4 : 8),
                Text('TAP', style: textStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidButtonPainter extends CustomPainter {
  const _LiquidButtonPainter({
    required this.scheme,
    required this.profile,
  });

  final ColorScheme scheme;
  final _LiquidProfile profile;

  @override
  void paint(Canvas canvas, Size size) {
    final outerPath = _buildBlobPath(size, profile, inset: 0);
    final innerPath = _buildBlobPath(size, profile * 0.6, inset: 12);
    final rect = Offset.zero & size;

    canvas.drawShadow(
      outerPath,
      scheme.primary.withValues(alpha: 0.26),
      22,
      false,
    );

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          scheme.primary.withValues(alpha: 0.94),
          scheme.primary.withValues(alpha: 0.82),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    canvas.drawPath(outerPath, fillPaint);

    final innerStroke = Paint()
      ..color = scheme.onPrimary.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    canvas.drawPath(innerPath, innerStroke);
  }

  Path _buildBlobPath(
    Size size,
    _LiquidProfile profile, {
    required double inset,
  }) {
    final rect = Rect.fromLTWH(
      inset,
      inset,
      math.max(size.width - inset * 2, 1),
      math.max(size.height - inset * 2, 1),
    );
    final center = rect.center;
    final radiusX = rect.width / 2;
    final radiusY = rect.height / 2;
    const pointCount = 10;
    final points = <Offset>[];

    for (var i = 0; i < pointCount; i++) {
      final angle = (math.pi * 2 * i) / pointCount - math.pi / 2;
      final dx = math.cos(angle);
      final dy = math.sin(angle);
      final sideBias =
          (profile.right * math.max(dx, 0)) +
          (profile.left * math.max(-dx, 0)) +
          (profile.bottom * math.max(dy, 0)) +
          (profile.top * math.max(-dy, 0));
      final leanBias = (profile.leanX * dx + profile.leanY * dy) * 0.16;
      final radial = (1 + sideBias * 0.16 + leanBias).clamp(0.86, 1.18);

      points.add(
        Offset(
          center.dx + dx * radiusX * radial,
          center.dy + dy * radiusY * radial,
        ),
      );
    }

    final path = Path();
    final start = _midpoint(points.last, points.first);
    path.moveTo(start.dx, start.dy);

    for (var i = 0; i < points.length; i++) {
      final current = points[i];
      final next = points[(i + 1) % points.length];
      final midpoint = _midpoint(current, next);
      path.quadraticBezierTo(current.dx, current.dy, midpoint.dx, midpoint.dy);
    }

    path.close();
    return path;
  }

  Offset _midpoint(Offset a, Offset b) =>
      Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);

  @override
  bool shouldRepaint(covariant _LiquidButtonPainter oldDelegate) {
    return oldDelegate.scheme != scheme || oldDelegate.profile != profile;
  }
}

class _LiquidProfile {
  const _LiquidProfile({
    required this.top,
    required this.right,
    required this.bottom,
    required this.left,
    required this.leanX,
    required this.leanY,
  });

  static const zero = _LiquidProfile(
    top: 0,
    right: 0,
    bottom: 0,
    left: 0,
    leanX: 0,
    leanY: 0,
  );

  final double top;
  final double right;
  final double bottom;
  final double left;
  final double leanX;
  final double leanY;

  static _LiquidProfile lerp(
    _LiquidProfile a,
    _LiquidProfile b,
    double t,
  ) {
    return _LiquidProfile(
      top: lerpDouble(a.top, b.top, t)!,
      right: lerpDouble(a.right, b.right, t)!,
      bottom: lerpDouble(a.bottom, b.bottom, t)!,
      left: lerpDouble(a.left, b.left, t)!,
      leanX: lerpDouble(a.leanX, b.leanX, t)!,
      leanY: lerpDouble(a.leanY, b.leanY, t)!,
    );
  }

  _LiquidProfile operator *(double factor) {
    return _LiquidProfile(
      top: top * factor,
      right: right * factor,
      bottom: bottom * factor,
      left: left * factor,
      leanX: leanX * factor,
      leanY: leanY * factor,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _LiquidProfile &&
        other.top == top &&
        other.right == right &&
        other.bottom == bottom &&
        other.left == left &&
        other.leanX == leanX &&
        other.leanY == leanY;
  }

  @override
  int get hashCode => Object.hash(top, right, bottom, left, leanX, leanY);
}
