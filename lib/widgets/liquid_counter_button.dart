import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class LiquidButton extends StatefulWidget {
  const LiquidButton({
    super.key,
    required this.onTap,
    required this.child,
    this.size = 250.0,
    this.color = const Color(0xFF3B82F6),
  });

  final VoidCallback onTap;
  final Widget child;
  final double size;
  final Color color;

  @override
  State<LiquidButton> createState() => _LiquidButtonState();
}

class _LiquidButtonState extends State<LiquidButton> {
  Timer? _timer;
  late BorderRadius _borderRadius;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _borderRadius = BorderRadius.circular(widget.size / 2);
  }

  @override
  void didUpdateWidget(covariant LiquidButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.size != widget.size) {
      _borderRadius = BorderRadius.circular(widget.size / 2);
    }
  }

  void _animateShape() {
    double radius() {
      final randomPercent = _random.nextInt(41) + 30;
      return widget.size * (randomPercent / 100);
    }

    setState(() {
      _borderRadius = BorderRadius.only(
        topLeft: Radius.elliptical(radius(), radius()),
        topRight: Radius.elliptical(radius(), radius()),
        bottomRight: Radius.elliptical(radius(), radius()),
        bottomLeft: Radius.elliptical(radius(), radius()),
      );
    });

    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _borderRadius = BorderRadius.circular(widget.size / 2);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _animateShape();
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: _borderRadius,
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.4),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}
