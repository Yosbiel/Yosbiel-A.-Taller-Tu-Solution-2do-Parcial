import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/screens/home_navigator.dart';

void main() {
  // ProviderScope es obligatorio para que Riverpod gestione los estados en toda la aplicación
  runApp(const ProviderScope(child: TuSolutionApp()));
}

class TuSolutionApp extends StatelessWidget {
  const TuSolutionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tu Solution',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Iniciamos con el navegador inferior que unifica Órdenes, Inventario y Consultas
      home: const HomeNavigator(),
      debugShowCheckedModeBanner: false,
    );
  }
}
