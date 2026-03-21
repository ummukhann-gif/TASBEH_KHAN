import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_state.dart';
import '../app_strings.dart';
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
  late final PageController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final strings = app.strings;

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const CounterScreen(),
          DhikrScreen(
            onOpenCounter: () => _selectIndex(0),
            onOpenAdd: _openAddDhikr,
          ),
          StatsScreen(
            onOpenCounter: () => _selectIndex(0),
            onOpenDhikr: () => _selectIndex(1),
          ),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _TerraBottomNavigationBar(
        currentIndex: _currentIndex,
        strings: strings,
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

    setState(() => _currentIndex = index);
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }
}

class _TerraBottomNavigationBar extends StatelessWidget {
  const _TerraBottomNavigationBar({
    required this.currentIndex,
    required this.strings,
    required this.onTap,
  });

  final int currentIndex;
  final AppStrings strings;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
