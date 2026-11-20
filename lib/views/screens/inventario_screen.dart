import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../viewmodels/talleres_providers.dart';

class InventarioScreen extends ConsumerWidget {
  const InventarioScreen({Key? key}) : super(key: key);

  void _mostrarFormulario(
    BuildContext context,
    WidgetRef ref, {
    RepuestosData? repuesto,
  }) {
    final esEdicion = repuesto != null;
    final formKey = GlobalKey<FormState>();
    final codigoCtrl = TextEditingController(text: repuesto?.codigo ?? '');
    final nombreCtrl = TextEditingController(text: repuesto?.nombre ?? '');
    final precioCtrl = TextEditingController(
      text: repuesto != null ? repuesto.precio.toString() : '',
    );
    final stockCtrl = TextEditingController(
      text: repuesto != null ? repuesto.existencias.toString() : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(esEdicion ? 'Editar repuesto' : 'Nuevo repuesto'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: codigoCtrl,
                  decoration: const InputDecoration(labelText: 'Codigo'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
                ),
                TextFormField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
                ),
                TextFormField(
                  controller: precioCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Precio'),
                  validator: (v) {
                    final n =
                        double.tryParse((v ?? '').trim().replaceAll(',', '.'));
                    if (n == null || n < 0) return 'Precio invalido';
                    return null;
                  },
                ),
                TextFormField(
                  controller: stockCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Existencias'),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    if (n == null || n < 0) return 'Stock invalido';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final precio = double.parse(
                  precioCtrl.text.trim().replaceAll(',', '.'));
              final stock = int.parse(stockCtrl.text.trim());
              try {
                final dao = ref.read(talleresDaoProvider);
                if (esEdicion) {
                  await dao.actualizarRepuesto(
                    id: repuesto.id,
                    codigo: codigoCtrl.text.trim(),
                    nombre: nombreCtrl.text.trim(),
                    precio: precio,
                    existencias: stock,
                  );
                } else {
                  await dao.insertarRepuesto(
                    codigoCtrl.text.trim(),
                    nombreCtrl.text.trim(),
                    precio,
                    stock,
                  );
                }
                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(esEdicion
                          ? 'Repuesto actualizado'
                          : 'Repuesto creado'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: Text(esEdicion ? 'Guardar' : 'Crear'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarEliminar(
    BuildContext context,
    WidgetRef ref,
    RepuestosData repuesto,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar repuesto'),
        content: Text(
          'Se eliminara "${repuesto.nombre}" (${repuesto.codigo}). '
          'No se puede deshacer.',
        ),
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
            return const Center(child: Text('No hay repuestos registrados.'));
          }
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final item = lista[i];
              final stockBajo = item.existencias <= 3;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    stockBajo
                        ? Icons.warning_amber_rounded
                        : Icons.inventory_2,
                    color: stockBajo
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                  title: Text('${item.nombre} (${item.codigo})'),
                  subtitle:
                      Text('Precio: \$${item.precio.toStringAsFixed(2)}'),
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
                            _mostrarFormulario(context, ref, repuesto: item);
                          } else if (v == 'eliminar') {
                            _confirmarEliminar(context, ref, item);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'editar', child: Text('Editar')),
                          PopupMenuItem(
                              value: 'eliminar', child: Text('Eliminar')),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
