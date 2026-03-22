import 'package:flutter/material.dart';

import 'app_state.dart';
import 'screens/main_shell.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = await TasbihAppState.load();
  runApp(TerraTasbihApp(state: state));
}

class TerraTasbihApp extends StatelessWidget {
  const TerraTasbihApp({super.key, required this.state});

  final TasbihAppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: state,
      child: ValueListenableBuilder<int>(
        valueListenable: state.themeNotifier,
        builder: (context, _, __) {
          return MaterialApp(
            title: 'Terra Tasbih',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.buildTheme(
              palette: state.palette,
              brightness: Brightness.light,
            ),
            darkTheme: AppTheme.buildTheme(
              palette: state.palette,
              brightness: Brightness.dark,
            ),
            themeMode: state.darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              return MediaQuery(
                data: mediaQuery.copyWith(
                  textScaler: TextScaler.linear(state.textScale),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const MainShell(),
          );
        },
      ),
    );
  }
}
