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

  final List<Widget> _screens = const [
    CounterScreen(),
    DhikrScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allow content to flow behind bottom nav
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E3230).withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: const Color(0xFFfaf6f0).withOpacity(0.95),
            indicatorColor: const Color(0xFF4a7c59).withOpacity(0.1),
            elevation: 0,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Symbols.fingerprint, color: Color(0x99705c30)),
                selectedIcon: Icon(Symbols.fingerprint, color: Color(0xFF4a7c59), fill: 1),
                label: 'Counter',
              ),
              NavigationDestination(
                icon: Icon(Symbols.format_list_bulleted, color: Color(0x99705c30)),
                selectedIcon: Icon(Symbols.format_list_bulleted, color: Color(0xFF4a7c59), fill: 1),
                label: 'Dhikr',
              ),
              NavigationDestination(
                icon: Icon(Symbols.bar_chart, color: Color(0x99705c30)),
                selectedIcon: Icon(Symbols.bar_chart, color: Color(0xFF4a7c59), fill: 1),
                label: 'Stats',
              ),
              NavigationDestination(
                icon: Icon(Symbols.settings, color: Color(0x99705c30)),
                selectedIcon: Icon(Symbols.settings, color: Color(0xFF4a7c59), fill: 1),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
