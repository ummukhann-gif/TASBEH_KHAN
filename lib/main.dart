import 'package:flutter/material.dart';
import 'app_state.dart';
import 'theme.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = await TasbihAppState.load();
  runApp(TerraTasbihApp(appState: appState));
}

class TerraTasbihApp extends StatelessWidget {
  const TerraTasbihApp({
    super.key,
    required this.appState,
  });

  final TasbihAppState appState;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: appState,
      child: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return MaterialApp(
            title: 'Terra Tasbih',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appState.darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
