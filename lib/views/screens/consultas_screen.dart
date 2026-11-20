import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/daos/talleres_dao.dart';
import '../../viewmodels/talleres_providers.dart';
import '../widgets/estado_pildora.dart';
import 'detalle_orden_screen.dart';

class ConsultasScreen extends ConsumerStatefulWidget {
  const ConsultasScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsultasScreen> createState() => _ConsultasScreenState();
}

class _ConsultasScreenState extends ConsumerState<ConsultasScreen> {
  final _equipoCtrl = TextEditingController();
  final _clienteCtrl = TextEditingController();
  String _busquedaEquipo = '';
  String _busquedaCliente = '';

  @override
  void dispose() {
    _equipoCtrl.dispose();
    _clienteCtrl.dispose();
    super.dispose();
  }

  String _formatearFecha(DateTime fecha) {
    final d = fecha.day.toString().padLeft(2, '0');
    final m = fecha.month.toString().padLeft(2, '0');
    final y = fecha.year.toString();
    return '$d/$m/$y';
  }

  Widget _tarjeta(HistorialOrdenItem item, {required bool mostrarCliente}) {
    final tecnico = item.tecnicoNombre ?? 'Sin asignar';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          '${item.equipo.tipo} ${item.equipo.marca} ${item.equipo.modelo} (S/N: ${item.equipo.numeroSerie})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (mostrarCliente)
                Text('Cliente: ${item.cliente.nombre} (${item.cliente.telefono})')
              else
                Text('Dueno: ${item.cliente.nombre} (${item.cliente.telefono})'),
              Text('Falla: ${item.orden.fallaReportada}'),
              const SizedBox(height: 4),
              Row(
                children: [
                  EstadoPildora(estado: item.orden.estado),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Tecnico: $tecnico')),
                ],
              ),
              Text('Fecha: ${_formatearFecha(item.orden.fechaCreacion)}'),
            ],
          ),
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetalleOrdenScreen(orden: item.orden),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cargaAsync = ref.watch(cargaTrabajoProvider);
    final repuestosStockBajoAsync = ref.watch(repuestosStockBajoProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Consultas y carga del taller'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.analytics), text: 'Carga y stock'),
              Tab(icon: Icon(Icons.history), text: 'Historial'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Carga por tecnico',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                cargaAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                  data: (carga) {
                    if (carga.isEmpty) {
                      return const Text('No hay ordenes activas.');
                    }
                    return Column(
                      children: carga.entries.map((e) {
                        return Card(
                          child: ListTile(
                            title: Text('Tecnico: ${e.key}'),
                            trailing: Text(
                              '${e.value} ordenes activas',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const Divider(height: 32),
                const Text('Repuestos con stock bajo',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
                const SizedBox(height: 8),
                repuestosStockBajoAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
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
                            subtitle: Text('Codigo: ${rep.codigo}'),
                            trailing: Text(
                              'Stock: ${rep.existencias}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Historial por equipo (serie, marca o modelo)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _equipoCtrl,
                  decoration: InputDecoration(
                    labelText: 'Ej. numero de serie, marca o modelo',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => setState(
                          () => _busquedaEquipo = _equipoCtrl.text.trim()),
                    ),
                  ),
                  onSubmitted: (v) =>
                      setState(() => _busquedaEquipo = v.trim()),
                ),
                const SizedBox(height: 10),
                if (_busquedaEquipo.isNotEmpty)
                  ref.watch(historialEquipoProvider(_busquedaEquipo)).when(
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Text('Error: $e'),
                        data: (res) {
                          if (res.isEmpty) {
                            return const Text('Sin resultados.');
                          }
                          return Column(
                            children: res
                                .map((i) => _tarjeta(i, mostrarCliente: false))
                                .toList(),
                          );
                        },
                      ),
                const Divider(height: 32),
                const Text('Historial por cliente (nombre o telefono)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _clienteCtrl,
                  decoration: InputDecoration(
                    labelText: 'Ej. nombre o telefono',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => setState(
                          () => _busquedaCliente = _clienteCtrl.text.trim()),
                    ),
                  ),
                  onSubmitted: (v) =>
                      setState(() => _busquedaCliente = v.trim()),
                ),
                const SizedBox(height: 10),
                if (_busquedaCliente.isNotEmpty)
                  ref.watch(historialClienteProvider(_busquedaCliente)).when(
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Text('Error: $e'),
                        data: (res) {
                          if (res.isEmpty) {
                            return const Text('Sin resultados.');
                          }
                          return Column(
                            children: res
                                .map((i) => _tarjeta(i, mostrarCliente: true))
                                .toList(),
                          );
                        },
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
