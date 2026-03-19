import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _count = 0;
  final int _target = 33;

  void _increment() {
    setState(() {
      if (_count < _target) {
        _count++;
      }
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Symbols.menu),
          onPressed: () {},
        ),
        title: const Text('Terra Tasbih', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Symbols.history),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Selection/Context Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.onBackground.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CURRENT DHIKR',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppTheme.tertiary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                        ),
                        Text(
                          'SubhanAllah',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Symbols.expand_more, color: AppTheme.primary),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Progress Ring Visualization (Decorative)
                      Container(
                        width: 320,
                        height: 320,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.primary.withOpacity(0.1), width: 4),
                        ),
                        child: Center(
                          child: Container(
                            width: 288,
                            height: 288,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.primary.withOpacity(0.05), width: 2),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Counter Typography
                          Text(
                            '$_count',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: AppTheme.primary,
                                  fontSize: 96,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -2,
                                  height: 1,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Symbols.target, color: AppTheme.primary, size: 16, fill: 1),
                                const SizedBox(width: 4),
                                Text(
                                  '$_count / $_target',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppTheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Symbols.expand_more, color: AppTheme.primary, size: 16),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Organic Counter Button
                          GestureDetector(
                            onTap: _increment,
                            child: Container(
                              width: 256,
                              height: 256,
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.9),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(150),
                                  topRight: Radius.circular(100),
                                  bottomLeft: Radius.circular(175),
                                  bottomRight: Radius.circular(75),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(0.2),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 224,
                                  height: 224,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppTheme.onPrimary.withOpacity(0.2), width: 2),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(130),
                                      topRight: Radius.circular(90),
                                      bottomLeft: Radius.circular(150),
                                      bottomRight: Radius.circular(60),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Symbols.fingerprint, color: AppTheme.onPrimary, size: 48, fill: 1),
                                      const SizedBox(height: 8),
                                      Text(
                                        'TAP TO COUNT',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              color: AppTheme.onPrimary.withOpacity(0.8),
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Secondary Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(Symbols.refresh, 'RESET', _reset),
                  const SizedBox(width: 32),
                  _buildActionButton(Symbols.volume_up, 'SOUND', () {}),
                  const SizedBox(width: 32),
                  _buildActionButton(Symbols.vibration, 'HAPTIC', () {}),
                ],
              ),
              const SizedBox(height: 24),
              // Weekly Progress Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.tertiaryContainer.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.tertiaryContainer.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.tertiary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Symbols.trending_up, color: AppTheme.tertiary, fill: 1),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Goal Reached',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            "You've completed 4 sessions today.",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // padding for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.secondary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.secondary.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
