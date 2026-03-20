import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme.dart';

class LiquidButton extends StatefulWidget {
  const LiquidButton({
    super.key,
    required this.innerSize,
    required this.count,
    required this.target,
    required this.onTap,
    required this.isPressed,
  });

  final double innerSize;
  final int count;
  final int target;
  final VoidCallback onTap;
  final bool isPressed;

  @override
  State<LiquidButton> createState() => _LiquidButtonState();
}

class _LiquidButtonState extends State<LiquidButton> {
  late BorderRadius _currentRadius;
  Timer? _timer;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _currentRadius = _generateRandomBorderRadius();
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (mounted) {
        setState(() {
          _currentRadius = _generateRandomBorderRadius();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _randomizeRapidly() {
    int splashCount = 0;
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _currentRadius = _generateRandomBorderRadius();
      });
      splashCount++;
      if (splashCount > 2) {
        timer.cancel();
      }
    });
  }

  BorderRadius _generateRandomBorderRadius() {
    int r() => _random.nextInt(50) + 25; // Random between 25 and 75

    return BorderRadius.only(
      topLeft: Radius.elliptical(r().toDouble(), r().toDouble()),
      topRight: Radius.elliptical((100 - r()).toDouble(), r().toDouble()),
      bottomRight: Radius.elliptical(
        (100 - r()).toDouble(),
        (100 - r()).toDouble(),
      ),
      bottomLeft: Radius.elliptical(r().toDouble(), (100 - r()).toDouble()),
    );
  }

  BorderRadius _scaleRadius(BorderRadius radius, double size) {
    // We convert the 0-100 percentage values into actual pixels based on size
    return BorderRadius.only(
      topLeft: Radius.elliptical(
        radius.topLeft.x / 100 * size,
        radius.topLeft.y / 100 * size,
      ),
      topRight: Radius.elliptical(
        radius.topRight.x / 100 * size,
        radius.topRight.y / 100 * size,
      ),
      bottomRight: Radius.elliptical(
        radius.bottomRight.x / 100 * size,
        radius.bottomRight.y / 100 * size,
      ),
      bottomLeft: Radius.elliptical(
        radius.bottomLeft.x / 100 * size,
        radius.bottomLeft.y / 100 * size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final innerSize = widget.innerSize;
    final scaledRadius = _scaleRadius(_currentRadius, innerSize);

    return AnimatedScale(
      scale: widget.isPressed ? 0.965 : 1,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTap: () {
          _randomizeRapidly();
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          width: innerSize,
          height: innerSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [scheme.primary, AppTheme.primaryContainer],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: scaledRadius,
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
              borderRadius: scaledRadius,
              onTap: () {
                _randomizeRapidly();
                widget.onTap();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Symbols.fingerprint,
                      color: scheme.onPrimary,
                      size: innerSize * 0.18,
                      fill: 1,
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Text(
                        '${widget.count}',
                        key: ValueKey(widget.count),
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
                      'TAP',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.84),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
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
