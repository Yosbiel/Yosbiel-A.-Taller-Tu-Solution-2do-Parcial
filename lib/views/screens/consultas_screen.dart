import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/daos/talleres_dao.dart';
import '../../viewmodels/talleres_providers.dart';
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

  Widget _construirTarjetaHistorial(HistorialOrdenItem item, {required bool mostrarCliente}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          '${item.equipo.tipo} ${item.equipo.marca} ${item.equipo.modelo} (S/N: ${item.equipo.numeroSerie})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          mostrarCliente
              ? 'Cliente: ${item.cliente.nombre} (${item.cliente.telefono})\n'
                  'Falla: ${item.orden.fallaReportada}\n'
                  'Estado: ${item.orden.estado} | Técnico: ${item.orden.tecnicoAsignado ?? "Sin asignar"} | Fecha: ${_formatearFecha(item.orden.fechaCreacion)}'
              : 'Falla: ${item.orden.fallaReportada}\n'
                  'Dueño: ${item.cliente.nombre} (${item.cliente.telefono})\n'
                  'Estado: ${item.orden.estado} | Técnico: ${item.orden.tecnicoAsignado ?? "Sin asignar"} | Fecha: ${_formatearFecha(item.orden.fechaCreacion)}',
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
          title: const Text('Consultas y Carga del Taller'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.analytics), text: 'Carga y Stock'),
              Tab(icon: Icon(Icons.history), text: 'Historial'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Carga de Trabajo por Técnico',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
                            trailing: Text(
                              '${entry.value} órdenes activas',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const Divider(height: 32),
                const Text(
                  'Alerta: Repuestos con Stock Bajo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
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
                            trailing: Text(
                              'Stock: ${rep.existencias}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
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
                const Text(
                  'Historial por Equipo (Serie, Marca o Modelo)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _equipoCtrl,
                  decoration: InputDecoration(
                    labelText: 'Ej. número de serie, marca o modelo',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() => _busquedaEquipo = _equipoCtrl.text.trim());
                      },
                    ),
                  ),
                  onSubmitted: (val) => setState(() => _busquedaEquipo = val.trim()),
                ),
                const SizedBox(height: 10),
                if (_busquedaEquipo.isNotEmpty)
                  ref.watch(historialEquipoProvider(_busquedaEquipo)).when(
                        loading: () => const CircularProgressIndicator(),
                        error: (err, _) => Text('Error: $err'),
                        data: (resultados) {
                          if (resultados.isEmpty) {
                            return const Text('No se encontraron reparaciones para ese equipo.');
                          }
                          return Column(
                            children: resultados
                                .map((item) => _construirTarjetaHistorial(item, mostrarCliente: false))
                                .toList(),
                          );
                        },
                      ),
                const Divider(height: 32),
                const Text(
                  'Historial por Cliente (Nombre o Teléfono)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _clienteCtrl,
                  decoration: InputDecoration(
                    labelText: 'Ej. nombre o teléfono del cliente',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() => _busquedaCliente = _clienteCtrl.text.trim());
                      },
                    ),
                  ),
                  onSubmitted: (val) => setState(() => _busquedaCliente = val.trim()),
                ),
                const SizedBox(height: 10),
                if (_busquedaCliente.isNotEmpty)
                  ref.watch(historialClienteProvider(_busquedaCliente)).when(
                        loading: () => const CircularProgressIndicator(),
                        error: (err, _) => Text('Error: $err'),
                        data: (resultados) {
                          if (resultados.isEmpty) {
                            return const Text('No se encontraron reparaciones para ese cliente.');
                          }
                          return Column(
                            children: resultados
                                .map((item) => _construirTarjetaHistorial(item, mostrarCliente: true))
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
