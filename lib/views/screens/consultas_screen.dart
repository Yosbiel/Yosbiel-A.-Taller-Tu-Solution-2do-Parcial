import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/daos/talleres_dao.dart';
import '../../data/database/app_database.dart';
import '../../viewmodels/talleres_providers.dart';
import '../widgets/estado_pildora.dart';
import 'detalle_orden_screen.dart';
import '../widgets/animaciones.dart';

class ConsultasScreen extends ConsumerStatefulWidget {
  const ConsultasScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsultasScreen> createState() => _ConsultasScreenState();
}

class _ConsultasScreenState extends ConsumerState<ConsultasScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  final _busquedaCtrl = TextEditingController();
  String _busqueda = '';
  Timer? _debounce;

  // Nuevo estado para el toggle Equipo/Cliente
  bool _buscarPorCliente = false;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _tabCtrl.dispose();
    _busquedaCtrl.dispose();
    super.dispose();
  }

  void _onBuscar(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _busqueda = v.trim());
    });
  }

  String _formatearFecha(DateTime fecha) {
    final d = fecha.day.toString().padLeft(2, '0');
    final m = fecha.month.toString().padLeft(2, '0');
    final y = fecha.year.toString();
    return '$d/$m/$y';
  }

  // Widget unificado para mostrar una tarjeta de historial
  Widget _tarjeta(HistorialOrdenItem item) {
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
              Text('Cliente: ${item.cliente.nombre} (${item.cliente.telefono})'),
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
            RutaDeslizante(
              page: DetalleOrdenScreen(orden: item.orden),
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
              // --- PESTAÑA 1: CARGA Y STOCK ---
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text('Carga por técnico', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  cargaAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => Text('Error: $e'),
                    data: (carga) {
                      if (carga.isEmpty) return const Text('No hay órdenes activas.');
                      return Column(
                        children: carga.entries.map((e) {
                          return Card(
                            child: ListTile(
                              title: Text('Técnico: ${e.key}'),
                              trailing: Text('${e.value} órdenes activas', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const Divider(height: 32),
                  Text('Repuestos con stock bajo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.error)),
                  const SizedBox(height: 8),
                  repuestosStockBajoAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => Text('Error: $e'),
                    data: (lista) {
                      if (lista.isEmpty) return const Text('Todo el inventario tiene buen stock.');
                      return Column(
                        children: lista.map((rep) {
                          return Card(
                            color: theme.colorScheme.errorContainer,
                            child: ListTile(
                              title: Text(rep.nombre),
                              subtitle: Text('Código: ${rep.codigo}'),
                              trailing: Text('Stock: ${rep.existencias}', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onErrorContainer)),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
              
              // --- PESTAÑA 2: HISTORIAL ---
              Column(
                children: [
                  // Toggle Equipo / Cliente
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: false, label: Text('Equipo'), icon: Icon(Icons.devices)),
                        ButtonSegment(value: true, label: Text('Cliente'), icon: Icon(Icons.person)),
                      ],
                      selected: {_buscarPorCliente},
                      onSelectionChanged: (Set<bool> newSelection) {
                        setState(() {
                          _buscarPorCliente = newSelection.first;
                          _busqueda = ''; // Limpiar búsqueda al cambiar
                          _busquedaCtrl.clear();
                        });
                      },
                    ),
                  ),
                  // Buscador dinámico
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _busquedaCtrl,
                      decoration: InputDecoration(
                        labelText: _buscarPorCliente 
                            ? 'Buscar por nombre o teléfono...' 
                            : 'Buscar por serie, marca o modelo...',
                        prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: _onBuscar,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _busqueda.isEmpty
                        // Si no hay búsqueda, mostramos TODO el historial (con datos de cliente)
                        ? ref.watch(historialCompletoProvider).when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, _) => Center(child: Text('Error: $e')),
                            data: (res) {
                              if (res.isEmpty) return const Center(child: Text('No hay órdenes registradas.'));
                              return ListView(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                children: res.map((i) => _tarjeta(i)).toList(),
                              );
                            },
                          )
                        // Si hay búsqueda, usamos el provider correcto según el toggle
                        : (!_buscarPorCliente 
                            ? ref.watch(historialEquipoProvider(_busqueda))
                            : ref.watch(historialClienteProvider(_busqueda))
                          ).when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, _) => Center(child: Text('Error: $e')),
                            data: (res) {
                              if (res.isEmpty) return const Center(child: Text('Sin resultados.'));
                              return ListView(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                children: res.map((i) => _tarjeta(i)).toList(),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
