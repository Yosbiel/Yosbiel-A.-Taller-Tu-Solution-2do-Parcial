import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'viewmodels/talleres_providers.dart';
import 'views/screens/home_navigator.dart';

void main() {
  // Aseguramos que los bindings de Flutter estén listos antes de usar
  // SharedPreferences (que se usa para guardar el tema).
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: TuSolutionApp()));
}

// Función de nivel superior para construir el tema. Al estar fuera de la clase,
// evitamos recrearlo en cada rebuild del widget.
ThemeData _buildTheme(Brightness brightness) {
  final esOscuro = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: brightness,
    surface: esOscuro ? const Color(0xFF121212) : null,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: esOscuro ? const Color(0xFF121212) : null,
    cardColor: esOscuro ? const Color(0xFF1E1E1E) : null,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
    ),
  );
}

class TuSolutionApp extends ConsumerWidget {
  const TuSolutionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el provider del tema para que la UI cambie en tiempo real.
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Tu Solution',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: themeMode,
      home: const HomeNavigator(),
      debugShowCheckedModeBanner: false,
    );
  }
}
