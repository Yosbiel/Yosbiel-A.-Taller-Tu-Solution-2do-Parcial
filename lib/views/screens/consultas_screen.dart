import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/daos/talleres_dao.dart';
import '../../data/database/app_database.dart';
import '../../viewmodels/talleres_providers.dart';
import '../widgets/estado_pildora.dart';
import 'detalle_orden_screen.dart';

class ConsultasScreen extends ConsumerStatefulWidget {
  const ConsultasScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsultasScreen> createState() => _ConsultasScreenState();
}

class _ConsultasScreenState extends ConsumerState<ConsultasScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  final _equipoCtrl = TextEditingController();
  final _clienteCtrl = TextEditingController();
  String _busquedaEquipo = '';
  String _busquedaCliente = '';
  Timer? _debounceEquipo;
  Timer? _debounceCliente;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _debounceEquipo?.cancel();
    _debounceCliente?.cancel();
    _tabCtrl.dispose();
    _equipoCtrl.dispose();
    _clienteCtrl.dispose();
    super.dispose();
  }

  void _onBuscarEquipo(String v) {
    _debounceEquipo?.cancel();
    _debounceEquipo = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _busquedaEquipo = v.trim());
    });
  }

  void _onBuscarCliente(String v) {
    _debounceCliente?.cancel();
    _debounceCliente = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _busquedaCliente = v.trim());
    });
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
                Text('Dueño: ${item.cliente.nombre} (${item.cliente.telefono})'),
              Text('Falla: ${item.orden.fallaReportada}'),
              const SizedBox(height: 4),
              Row(
                children: [
                  EstadoPildora(estado: item.orden.estado),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Técnico: $tecnico')),
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

  // Tarjeta simple para cuando se muestran TODAS las ordenes (sin join)
  Widget _tarjetaSimple(OrdenesReparacionData orden) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text('Falla: ${orden.fallaReportada}'),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              EstadoPildora(estado: orden.estado),
              const SizedBox(width: 8),
              Text('Fecha: ${_formatearFecha(orden.fechaCreacion)}'),
            ],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetalleOrdenScreen(orden: orden),
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
    final theme = Theme.of(context);

    return Column(
      children: [
        TabBar(
          controller: _tabCtrl,
          tabs: const [
            Tab(icon: Icon(Icons.analytics), text: 'Carga y stock'),
            Tab(icon: Icon(Icons.history), text: 'Historial'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text('Carga por técnico',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  cargaAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => Text('Error: $e'),
                    data: (carga) {
                      if (carga.isEmpty) {
                        return const Text('No hay órdenes activas.');
                      }
                      return Column(
                        children: carga.entries.map((e) {
                          return Card(
                            child: ListTile(
                              title: Text('Técnico: ${e.key}'),
                              trailing: Text(
                                '${e.value} órdenes activas',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const Divider(height: 32),
                  Text('Repuestos con stock bajo',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.error)),
                  const SizedBox(height: 8),
                  repuestosStockBajoAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => Text('Error: $e'),
                    data: (lista) {
                      if (lista.isEmpty) {
                        return const Text(
                            'Todo el inventario tiene buen stock.');
                      }
                      return Column(
                        children: lista.map((rep) {
                          return Card(
                            color: theme.colorScheme.errorContainer,
                            child: ListTile(
                              title: Text(rep.nombre),
                              subtitle: Text('Código: ${rep.codigo}'),
                              trailing: Text(
                                'Stock: ${rep.existencias}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onErrorContainer,
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
                    'Historial de reparaciones. Sin filtro se muestran todas; escribe para buscar por equipo o cliente.',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 12),
                  _seccionHistorial(
                    titulo: 'Historial por equipo (serie, marca o modelo)',
                    ctrl: _equipoCtrl,
                    busqueda: _busquedaEquipo,
                    onChanged: _onBuscarEquipo,
                    mostrarCliente: false,
                  ),
                  const Divider(height: 32),
                  _seccionHistorial(
                    titulo: 'Historial por cliente (nombre o teléfono)',
                    ctrl: _clienteCtrl,
                    busqueda: _busquedaCliente,
                    onChanged: _onBuscarCliente,
                    mostrarCliente: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _seccionHistorial({
    required String titulo,
    required TextEditingController ctrl,
    required String busqueda,
    required void Function(String) onChanged,
    required bool mostrarCliente,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            labelText: 'Escribe para filtrar',
            prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
          ),
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
        
        // AQUI ESTA LA MAGIA: Si no hay busqueda, usa el Stream completo.
        // Si hay busqueda, usa el FutureProvider de filtro.
        if (busqueda.isEmpty)
          ref.watch(historialCompletoProvider).when(
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Error: $e'),
            data: (res) {
              if (res.isEmpty) return const Text('Sin resultados.');
              return Column(
                children: res.map((o) => _tarjetaSimple(o)).toList(),
              );
            },
          )
        else
          (mostrarCliente
            ? ref.watch(historialClienteProvider(busqueda))
            : ref.watch(historialEquipoProvider(busqueda))
          ).when(
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Error: $e'),
            data: (res) {
              if (res.isEmpty) return const Text('Sin resultados.');
              return Column(
                children: res.map((i) => _tarjeta(i, mostrarCliente: mostrarCliente)).toList(),
              );
            },
          ),
      ],
    );
  }
}
