import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  late final Ticker _ticker;

  _LiquidProfile _shape = _LiquidProfile.zero;
  _LiquidProfile _velocity = _LiquidProfile.zero;
  double _press = 0;
  double _pressVelocity = 0;
  Duration? _lastElapsed;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
  }

  @override
  void didUpdateWidget(covariant LiquidCounterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded && !oldWidget.expanded) {
      _stopMotion(reset: true);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _tick(Duration elapsed) {
    final dt = ((_lastElapsed == null
                ? const Duration(milliseconds: 16)
                : elapsed - _lastElapsed!)
            .inMicroseconds /
        1000000)
        .clamp(0.0, 0.03);
    _lastElapsed = elapsed;

    const shapeStiffness = 32.0;
    const shapeDamping = 10.5;
    const pressStiffness = 40.0;
    const pressDamping = 11.0;

    final shapeAcceleration =
        (_shape * -shapeStiffness) + (_velocity * -shapeDamping);
    _velocity += shapeAcceleration * dt;
    _shape += _velocity * dt;

    final pressAcceleration =
        (-_press * pressStiffness) + (-_pressVelocity * pressDamping);
    _pressVelocity += pressAcceleration * dt;
    _press += _pressVelocity * dt;

    if (_shape.maxComponent < 0.003 &&
        _velocity.maxComponent < 0.003 &&
        _press.abs() < 0.002 &&
        _pressVelocity.abs() < 0.002) {
      _stopMotion(reset: true);
      return;
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _stopMotion({required bool reset}) {
    _ticker.stop();
    _lastElapsed = null;
    if (reset) {
      setState(() {
        _shape = _LiquidProfile.zero;
        _velocity = _LiquidProfile.zero;
        _press = 0;
        _pressVelocity = 0;
      });
    }
  }

  _LiquidProfile _randomImpulse() {
    double range(double min, double max) =>
        min + _random.nextDouble() * (max - min);

    final dominantRight = _random.nextBool();
    final sidePush = range(0.32, 0.64);

    return _LiquidProfile(
      top: range(-0.10, 0.14),
      right: dominantRight ? sidePush : sidePush * 0.48,
      bottom: range(0.08, 0.22),
      left: dominantRight ? sidePush * 0.48 : sidePush,
      leanX: dominantRight ? range(0.20, 0.52) : range(-0.52, -0.20),
      leanY: range(-0.14, 0.14),
    );
  }

  void _triggerMorph() {
    if (widget.expanded) {
      return;
    }

    setState(() {
      _velocity += _randomImpulse() * 8.8;
      _pressVelocity -= 1.5;
    });

    if (!_ticker.isActive) {
      _lastElapsed = null;
      _ticker.start();
    }
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
        final scale = widget.expanded ? 0.986 : (1 + _press).clamp(0.92, 1.0);

        return Semantics(
          button: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _triggerMorph(),
            onTap: widget.onTap,
            child: Transform.scale(
              scale: scale,
              child: widget.expanded
                  ? _ExpandedTapButton(
                      width: width,
                      height: height,
                      scheme: scheme,
                    )
                  : _CollapsedLiquidButton(
                      size: Size(width, height),
                      scheme: scheme,
                      profile: _shape,
                    ),
            ),
          ),
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
  });

  final Size size;
  final ColorScheme scheme;
  final _LiquidProfile profile;

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

    return RepaintBoundary(
      child: CustomPaint(
        size: size,
        painter: _LiquidButtonPainter(
          scheme: scheme,
          profile: profile,
        ),
        child: SizedBox(
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
    final innerPath = _buildBlobPath(size, profile * 0.55, inset: 12);
    final rect = Offset.zero & size;

    canvas.drawShadow(
      outerPath,
      scheme.primary.withValues(alpha: 0.28),
      24,
      false,
    );

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          scheme.primary.withValues(alpha: 0.95),
          scheme.primary.withValues(alpha: 0.82),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    canvas.drawPath(outerPath, fillPaint);

    final innerStroke = Paint()
      ..color = scheme.onPrimary.withValues(alpha: 0.17)
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
    final center = rect.center.translate(
      rect.width * profile.leanX * 0.045,
      rect.height * profile.leanY * 0.035,
    );
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
      final leanBias = (profile.leanX * dx + profile.leanY * dy) * 0.18;
      final radial = (1 + sideBias * 0.18 + leanBias).clamp(0.84, 1.22);

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

  _LiquidProfile operator +(Object other) {
    final value = other as _LiquidProfile;
    return _LiquidProfile(
      top: top + value.top,
      right: right + value.right,
      bottom: bottom + value.bottom,
      left: left + value.left,
      leanX: leanX + value.leanX,
      leanY: leanY + value.leanY,
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

  double get maxComponent {
    return [
      top.abs(),
      right.abs(),
      bottom.abs(),
      left.abs(),
      leanX.abs(),
      leanY.abs(),
    ].reduce(math.max);
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
