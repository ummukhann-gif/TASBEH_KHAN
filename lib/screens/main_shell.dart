import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_state.dart';
import 'add_dhikr_screen.dart';
import 'counter_screen.dart';
import 'dhikr_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final Set<int> _visitedIndexes = {0};
  final Map<int, Widget> _screenCache = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(4, (index) {
          if (!_visitedIndexes.contains(index)) {
            return const SizedBox.shrink();
          }

          return TickerMode(
            enabled: _currentIndex == index,
            child: RepaintBoundary(child: _screenFor(index)),
          );
        }),
      ),
      bottomNavigationBar: _TerraBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _selectIndex,
      ),
    );
  }

  Future<void> _openAddDhikr() async {
    final created = await Navigator.of(context).push<bool>(
      PageRouteBuilder<bool>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: const AddDhikrScreen(),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.06),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          );
        },
      ),
    );

    if (created == true && mounted) {
      _selectIndex(0);
    }
  }

  void _selectIndex(int index) {
    if (_currentIndex == index) {
      return;
    }

    setState(() {
      _currentIndex = index;
      _visitedIndexes.add(index);
    });
  }

  Widget _screenFor(int index) {
    return _screenCache.putIfAbsent(index, () {
      switch (index) {
        case 0:
          return const CounterScreen();
        case 1:
          return DhikrScreen(
            onOpenCounter: () => _selectIndex(0),
            onOpenAdd: _openAddDhikr,
          );
        case 2:
          return StatsScreen(
            onOpenCounter: () => _selectIndex(0),
            onOpenDhikr: () => _selectIndex(1),
          );
        case 3:
          return const SettingsScreen();
        default:
          return const SizedBox.shrink();
      }
    });
  }
}

class _TerraBottomNavigationBar extends StatelessWidget {
  const _TerraBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final strings = AppScope.of(context).strings;

    final items = [
      _NavItemData(
        icon: Symbols.fingerprint,
        fillIcon: Symbols.fingerprint,
        label: strings.counter,
      ),
      _NavItemData(
        icon: Symbols.format_list_bulleted,
        fillIcon: Symbols.format_list_bulleted,
        label: strings.dhikr,
      ),
      _NavItemData(
        icon: Symbols.bar_chart,
        fillIcon: Symbols.bar_chart,
        label: strings.stats,
      ),
      _NavItemData(
        icon: Symbols.settings,
        fillIcon: Symbols.settings,
        label: strings.settings,
      ),
    ];

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: scheme.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: _TerraNavItem(
                  data: items[i],
                  selected: currentIndex == i,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TerraNavItem extends StatelessWidget {
  const _TerraNavItem({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _NavItemData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: BoxDecoration(
              color: selected
                  ? scheme.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? data.fillIcon : data.icon,
                  size: 22,
                  fill: selected ? 1 : 0,
                  color: selected
                      ? scheme.primary
                      : scheme.tertiary.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 4),
                Text(
                  data.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selected
                        ? scheme.primary
                        : scheme.tertiary.withValues(alpha: 0.7),
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.icon,
    required this.fillIcon,
    required this.label,
  });

  final IconData icon;
  final IconData fillIcon;
  final String label;
}
