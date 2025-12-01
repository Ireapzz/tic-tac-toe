import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/features/game/presentation/screens/game_screen.dart';
import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/core/theme/theme_mode_controller.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeControllerProvider);

    return MaterialApp(
      title: 'Tic-Tac-Toe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const GameScreen(),
    );
  }
}
