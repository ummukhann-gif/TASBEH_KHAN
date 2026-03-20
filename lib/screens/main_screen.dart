import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'counter_screen.dart';
import 'dhikr_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const CounterScreen(),
      DhikrScreen(onOpenCounter: () => _selectIndex(0)),
      StatsScreen(
        onOpenCounter: () => _selectIndex(0),
        onOpenDhikr: () => _selectIndex(1),
      ),
      const SettingsScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _selectIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            backgroundColor: Colors.transparent,
            destinations: const [
              NavigationDestination(
                icon: Icon(Symbols.fingerprint),
                selectedIcon: Icon(Symbols.fingerprint, fill: 1),
                label: 'Counter',
              ),
              NavigationDestination(
                icon: Icon(Symbols.format_list_bulleted),
                selectedIcon: Icon(Symbols.format_list_bulleted, fill: 1),
                label: 'Dhikr',
              ),
              NavigationDestination(
                icon: Icon(Symbols.bar_chart),
                selectedIcon: Icon(Symbols.bar_chart, fill: 1),
                label: 'Stats',
              ),
              NavigationDestination(
                icon: Icon(Symbols.settings),
                selectedIcon: Icon(Symbols.settings, fill: 1),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectIndex(int index) {
    if (_currentIndex == index) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
