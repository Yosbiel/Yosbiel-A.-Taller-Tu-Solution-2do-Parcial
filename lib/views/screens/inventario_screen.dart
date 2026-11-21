import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../viewmodels/talleres_providers.dart';
import '../widgets/boton_boing.dart';
import '../widgets/formulario_repuesto.dart';

class InventarioScreen extends ConsumerWidget {
  const InventarioScreen({Key? key}) : super(key: key);

  // Diálogo de confirmación antes de borrar un repuesto
  Future<void> _confirmarEliminar(
    BuildContext context,
    WidgetRef ref,
    RepuestosData repuesto,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar repuesto'),
        content: Text('Se eliminara "${repuesto.nombre}" (${repuesto.codigo}).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final dao = ref.read(talleresDaoProvider);
      await dao.eliminarRepuesto(repuesto.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Repuesto eliminado')),
        );
      }
    } catch (e) {
      // Si el repuesto está usado en una orden, el DAO lanza error y lo mostramos
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo eliminar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repuestosAsync = ref.watch(todosRepuestosProvider);
    final theme = Theme.of(context);
    
    return Scaffold(
      body: repuestosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text('No hay repuestos.'));
          }
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final item = lista[i];
              // Si el stock es de 3 o menos, se pinta de rojo como alerta
              final stockBajo = item.existencias <= 3;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    stockBajo ? Icons.warning_amber_rounded : Icons.inventory_2,
                    color: stockBajo ? theme.colorScheme.error : theme.colorScheme.primary,
                  ),
                  title: Text('${item.nombre} (${item.codigo})'),
                  subtitle: Text('Precio: \$${item.precio.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Stock: ${item.existencias}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: stockBajo ? theme.colorScheme.error : null,
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'editar') {
                            mostrarFormularioRepuesto(context, ref, repuesto: item);
                          } else if (v == 'eliminar') {
                            _confirmarEliminar(context, ref, item);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'editar', child: Text('Editar')),
                          PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: BotonBoing(
        tooltip: 'Nuevo repuesto',
        onPressed: () => mostrarFormularioRepuesto(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
