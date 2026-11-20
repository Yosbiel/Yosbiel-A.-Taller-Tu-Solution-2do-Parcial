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
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codigoCtrl,
                decoration: const InputDecoration(labelText: 'Codigo'),
              ),
              TextField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: precioCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Precio'),
              ),
              TextField(
                controller: stockCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Existencias'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final codigo = codigoCtrl.text.trim();
              final nombre = nombreCtrl.text.trim();
              final precio =
                  double.tryParse(precioCtrl.text.trim().replaceAll(',', '.'));
              final stock = int.tryParse(stockCtrl.text.trim());
              if (codigo.isEmpty || nombre.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Codigo y nombre son obligatorios.')),
                );
                return;
              }
              if (precio == null || precio < 0 || stock == null || stock < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Precio y stock deben ser validos.')),
                );
                return;
              }
              try {
                final dao = ref.read(talleresDaoProvider);
                if (esEdicion) {
                  await dao.actualizarRepuesto(
                    id: repuesto.id,
                    codigo: codigo,
                    nombre: nombre,
                    precio: precio,
                    existencias: stock,
                  );
                } else {
                  await dao.insertarRepuesto(codigo, nombre, precio, stock);
                }
                if (ctx.mounted) Navigator.pop(ctx);
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
          'Esta accion no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final dao = ref.read(talleresDaoProvider);
      await dao.eliminarRepuesto(repuesto.id);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Almacen de repuestos')),
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
                    stockBajo ? Icons.warning_amber_rounded : Icons.inventory_2,
                    color: stockBajo ? Colors.red : Colors.blue,
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
                          color: stockBajo ? Colors.red : null,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
