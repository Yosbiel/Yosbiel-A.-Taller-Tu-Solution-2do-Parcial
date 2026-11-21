import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/talleres_providers.dart';
import '../widgets/estado_pildora.dart';
import 'nueva_orden_screen.dart';
import 'detalle_orden_screen.dart';
import '../widgets/animaciones.dart';
import '../widgets/boton_boing.dart';

class OrdenesScreen extends ConsumerWidget {
  const OrdenesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el stream de órdenes abiertas para que la UI se actualice sola
    final ordenesAsync = ref.watch(ordenesAbiertasProvider);
    final tecnicosAsync = ref.watch(tecnicosProvider);

    return Scaffold(
      body: ordenesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (ordenes) {
          if (ordenes.isEmpty) {
            return const Center(child: Text('No hay ordenes abiertas.'));
          }
          // Mapeamos los técnicos por ID para buscar el nombre rápido en la lista
          final tecnicos = tecnicosAsync.valueOrNull ?? const [];
          final porId = {for (final t in tecnicos) t.id: t.nombre};
          
          return ListView.builder(
            itemCount: ordenes.length,
            itemBuilder: (context, i) {
              final orden = ordenes[i];
              final tecnico = orden.tecnicoId == null
                  ? 'Sin asignar'
                  : (porId[orden.tecnicoId] ?? 'Sin asignar');
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text('Falla: ${orden.fallaReportada}'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        // Píldora de color según el estado de la orden
                        EstadoPildora(estado: orden.estado),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Técnico: $tecnico')),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navegación con animación personalizada
                    Navigator.push(
                      context,
                      RutaDeslizante(
                        page: DetalleOrdenScreen(orden: orden),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: BotonBoing(
        tooltip: 'Nueva orden',
        onPressed: () {
          Navigator.push(
            context,
            RutaDeslizante(page: const NuevaOrdenScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
