import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/talleres_providers.dart';

final cargaTrabajoProvider = FutureProvider.autoDispose>((ref) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.obtenerCargaTrabajoPorTecnico();
});

class ConsultasScreen extends ConsumerWidget {
  const ConsultasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cargaAsync = ref.watch(cargaTrabajoProvider);
    final repuestosStockBajoAsync = ref.watch(repuestosStockBajoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Consultas y Carga del Taller')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Carga de Trabajo por Técnico', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          cargaAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (err, _) => Text('Error: $err'),
            data: (carga) {
              if (carga.isEmpty) {
                return const Text('No hay órdenes activas asignadas.');
              }
              return Column(
                children: carga.entries.map((entry) {
                  return Card(
                    child: ListTile(
                      title: Text('Técnico: ${entry.key}'),
                      trailing: Text('${entry.value} órdenes activas',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const Divider(height: 32),
          const Text('Alerta: Repuestos con Stock Bajo', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 8),
          repuestosStockBajoAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (err, _) => Text('Error: $err'),
            data: (lista) {
              if (lista.isEmpty) {
                return const Text('Todo el inventario tiene buen stock.');
              }
              return Column(
                children: lista.map((rep) {
                  return Card(
                    color: Colors.red.shade50,
                    child: ListTile(
                      title: Text(rep.nombre),
                      subtitle: Text('Código: ${rep.codigo}'),
                      trailing: Text('Stock: ${rep.existencias}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
