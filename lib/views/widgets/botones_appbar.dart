import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/talleres_providers.dart';

// Boton sol/luna para alternar el tema.
class BotonTema extends ConsumerWidget {
  const BotonTema({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modo = ref.watch(themeModeProvider);
    final esOscuro = modo == ThemeMode.dark ||
        (modo == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return IconButton(
      tooltip: esOscuro ? 'Modo claro' : 'Modo oscuro',
      icon: Icon(esOscuro ? Icons.light_mode : Icons.dark_mode),
      onPressed: () {
        ref.read(themeModeProvider.notifier).state =
            esOscuro ? ThemeMode.light : ThemeMode.dark;
      },
    );
  }
}

// Boton de informacion con dialog de creditos.
class BotonInfo extends StatelessWidget {
  const BotonInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Acerca de',
      icon: const Icon(Icons.info_outline),
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Tu Solution'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sistema de gestion para taller de reparaciones.'),
                SizedBox(height: 8),
                Text('Programacion para Dispositivos Moviles'),
                Text('Ingenieria Informatica - 3er ano'),
                SizedBox(height: 8),
                Text('Flutter + Drift + Riverpod'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
