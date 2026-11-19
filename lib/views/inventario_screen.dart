import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/talleres_providers.dart';

class InventarioScreen extends ConsumerWidget {
  const InventarioScreen({Key? key}) : super(key: key);

  void _mostrarDialogoNuevoRepuesto(BuildContext context, WidgetRef ref) {
    final codigoCtrl = TextEditingController();
    final nombreCtrl = TextEditingController();
    final precioCtrl = TextEditingController();
    final stockCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo Repuesto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: codigoCtrl, decoration: const InputDecoration(labelText: 'Código')),
              TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(
                controller: precioCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: stockCtrl,
                decoration: const InputDecoration(labelText: 'Existencias iniciales'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final codigo = codigoCtrl.text.trim();
              final nombre = nombreCtrl.text.trim();
              final precio = double.tryParse(precioCtrl.text.trim().replaceAll(',', '.'));
              final stock = int.tryParse(stockCtrl.text.trim());

              if (codigo.isEmpty || nombre.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Código y nombre son obligatorios.')),
                );
                return;
              }
              if (precio == null || precio < 0 || stock == null || stock < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ingresa precio y existencias válidas (0 o mayores).')),
                );
                return;
              }

              try {
                final dao = ref.read(talleresDaoProvider);
                await dao.insertarRepuesto(codigo, nombre, precio, stock);
                ref.invalidate(todosRepuestosProvider);
                ref.invalidate(repuestosStockBajoProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al guardar repuesto: $e')),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repuestosAsync = ref.watch(todosRepuestosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Almacén de Repuestos')),
      body: repuestosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text('No hay repuestos registrados en el almacén.'));
          }
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final item = lista[index];
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
                  trailing: Text(
                    'Stock: ${item.existencias}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: stockBajo ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoNuevoRepuesto(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
