import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'viewmodels/talleres_providers.dart';
import 'views/screens/home_navigator.dart';

void main() {
  runApp(const ProviderScope(child: TuSolutionApp()));
}

class TuSolutionApp extends ConsumerWidget {
  const TuSolutionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    ThemeData buildTheme(Brightness brightness) {
      final scheme = ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: brightness,
      );
      return ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
      );
    }

    return MaterialApp(
      title: 'Tu Solution',
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: themeMode,
      home: const HomeNavigator(),
      debugShowCheckedModeBanner: false,
    );
  }
}
