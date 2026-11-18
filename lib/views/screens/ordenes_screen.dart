import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/talleres_providers.dart';
import 'nueva_orden_screen.dart';
import 'detalle_orden_screen.dart';

// Usamos ConsumerWidget para poder escuchar los providers de Riverpod fácilmente
class OrdenesScreen extends ConsumerWidget {
  const OrdenesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el StreamProvider de órdenes abiertas
    final ordenesAsync = ref.watch(ordenesAbiertasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Solution - Taller'),
      ),
      body: ordenesAsync.when(
        // 1- Mientras cargan los datos de la base de datos local (Drift)
        loading: () => const Center(child: CircularProgressIndicator()),
        
        // 2- Si ocurre algún error en la consulta
        error: (err, stack) => Center(child: Text('Error al cargar órdenes: $err')),
        
        // 3- Cuando los datos llegan correctamente
        data: (ordenes) {
          if (ordenes.isEmpty) {
            return const Center(
              child: Text('No hay órdenes abiertas en este momento.'),
            );
          }

          return ListView.builder(
            itemCount: ordenes.length,
            itemBuilder: (context, index) {
              final orden = ordenes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text('Falla: ${orden.fallaReportada}'),
                  subtitle: Text(
                    'Estado: ${orden.estado} \nTécnico: ${orden.tecnicoAsignado ?? "Sin asignar"}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navegamos a la pantalla de detalle de la orden
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleOrdenScreen(orden: orden),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      // Botón para ir a registrar una nueva orden
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NuevaOrdenScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
