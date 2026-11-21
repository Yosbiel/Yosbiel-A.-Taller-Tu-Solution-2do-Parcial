import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/talleres_providers.dart';

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
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => RotationTransition(
          turns: animation,
          child: ScaleTransition(scale: animation, child: child),
        ),
        child: Icon(
          esOscuro ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey<bool>(esOscuro),
        ),
      ),
      onPressed: () {
        ref.read(themeModeProvider.notifier).setMode(
              esOscuro ? ThemeMode.light : ThemeMode.dark,
            );
      },
    );
  }
}

class BotonInfo extends StatelessWidget {
  const BotonInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: 'Acerca de',
      icon: const Icon(Icons.info_outline),
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: scheme.primary,
                  child: Icon(Icons.build, color: scheme.onPrimary),
                ),
                const SizedBox(width: 12),
                const Text('Tu Solution'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sistema de gestión para taller de reparaciones.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                _fila(context, Icons.school, 'Ingeniería Informática - 3er año'),
                const SizedBox(height: 6),
                _fila(context, Icons.phone_android, 'Programación para Dispositivos Móviles'),
                const SizedBox(height: 6),
                _fila(context, Icons.code, 'Flutter + Drift + Riverpod'),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
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

  Widget _fila(BuildContext context, IconData icono, String texto) {
    return Row(
      children: [
        Icon(icono, size: 16, color: Theme.of(context).colorScheme.onSurface),
        const SizedBox(width: 8),
        Expanded(child: Text(texto, style: const TextStyle(fontSize: 13))),
      ],
    );
  }
}
