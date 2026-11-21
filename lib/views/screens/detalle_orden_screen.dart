import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/daos/talleres_dao.dart';
import '../../data/database/app_database.dart';
import '../../viewmodels/detalle_orden_viewmodel.dart';
import '../../viewmodels/talleres_providers.dart';
import '../widgets/estado_pildora.dart';
import '../widgets/dialogo_repuesto.dart';

class DetalleOrdenScreen extends ConsumerStatefulWidget {
  final OrdenesReparacionData orden;
  const DetalleOrdenScreen({Key? key, required this.orden}) : super(key: key);

  @override
  ConsumerState<DetalleOrdenScreen> createState() => _DetalleOrdenScreenState();
}

class _DetalleOrdenScreenState extends ConsumerState<DetalleOrdenScreen> {
  late String _estadoActual;
  late String _estadoOriginal;
  int? _tecnicoId;
  int? _tecnicoOriginal;
  final _trabajoDescCtrl = TextEditingController();
  final _trabajoCostoCtrl = TextEditingController();

  bool get _esFinal =>
      _estadoActual == 'entregada' || _estadoActual == 'cancelada';

  bool get _puedeEditarTrabajo => _estadoActual == 'en_reparacion';

  bool get _hayCambios =>
      _estadoActual != _estadoOriginal || _tecnicoId != _tecnicoOriginal;

  @override
  void initState() {
    super.initState();
    _estadoActual = widget.orden.estado;
    _estadoOriginal = widget.orden.estado;
    _tecnicoId = widget.orden.tecnicoId;
    _tecnicoOriginal = widget.orden.tecnicoId;
  }

  @override
  void dispose() {
    _trabajoDescCtrl.dispose();
    _trabajoCostoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar(DetalleOrdenViewModel vm) async {
    try {
      final dao = ref.read(talleresDaoProvider);
      if (_tecnicoId != _tecnicoOriginal) {
        await dao.reasignarTecnicoUI(widget.orden.id, _tecnicoId);
      }
      await vm.guardarCambios(_estadoActual, _tecnicoId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orden actualizada')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _liberar(DetalleOrdenViewModel vm) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Liberar orden'),
        content: const Text('La orden quedara sin tecnico asignado.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Liberar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      // La pantalla solo interactua con el ViewModel, no con el DAO.
      await vm.liberarOrden();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orden liberada')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _agregarTrabajo(DetalleOrdenViewModel vm) async {
    final desc = _trabajoDescCtrl.text.trim();
    final costo =
        double.tryParse(_trabajoCostoCtrl.text.trim().replaceAll(',', '.'));
    if (desc.isEmpty || costo == null || costo <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Descripción y costo válidos.')),
      );
      return;
    }
    try {
      await vm.agregarTrabajo(desc, costo);
      _trabajoDescCtrl.clear();
      _trabajoCostoCtrl.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mano de obra registrada')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _agregarRepuesto(DetalleOrdenViewModel vm) async {
    final dao = ref.read(talleresDaoProvider);
    final repuestos = await dao.obtenerTodosRepuestos();
    if (!mounted) return;
    
    if (repuestos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sin repuestos en almacén.")),
      );
      return;
    }

    final sel = await mostrarSelectorRepuesto(context, repuestos);
    if (sel == null || !mounted) return;

    final cant = await mostrarCantidadRepuesto(context, sel);
    if (cant == null || !mounted) return;

    try {
      await vm.agregarRepuesto(sel.id, cant);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Se agregaron $cant x ${sel.nombre}")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(detalleOrdenProvider(widget.orden));
    final tecnicosAsync = ref.watch(tecnicosProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Orden #${widget.orden.id}')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (state) {
          final vm = ref.read(detalleOrdenProvider(widget.orden).notifier);
          final tecnicos = tecnicosAsync.valueOrNull ?? const [];
          final nombreTecnico = _tecnicoId == null
              ? 'Sin asignar'
              : tecnicos
                      .where((t) => t.id == _tecnicoId)
                      .map((t) => t.nombre)
                      .firstOrNull ??
                  'Sin asignar';
          // Usamos el diccionario centralizado en estado_pildora.dart
          final permitidos = transicionesPermitidas[_estadoOriginal] ?? const [];
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Falla: ${widget.orden.fallaReportada}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  EstadoPildora(estado: _estadoActual),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Costo total: \$${state.costoTotal.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary),
              ),
              const Divider(height: 24),
              if (_esFinal)
                Text('Técnico: $nombreTecnico',
                    style: const TextStyle(fontSize: 14))
              else ...[
                DropdownButtonFormField<int?>(
                  value: _tecnicoId,
                  decoration:
                      const InputDecoration(labelText: 'Técnico responsable'),
                  items: [
                    const DropdownMenuItem<int?>(
                        value: null, child: Text('Sin asignar')),
                    ...tecnicos.map(
                      (t) => DropdownMenuItem<int?>(
                          value: t.id, child: Text(t.nombre)),
                    ),
                  ],
                  onChanged: (v) => setState(() => _tecnicoId = v),
                ),
                if (_tecnicoId != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _liberar(vm),
                      icon: const Icon(Icons.person_off, size: 18),
                      label: const Text('Liberar orden'),
                    ),
                  ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _estadoActual,
                  decoration: const InputDecoration(labelText: 'Estado'),
                  items: todosLosEstados.map((e) {
                    final esActual = e == _estadoActual;
                    final esPermitido = permitidos.contains(e) || esActual;
                    return DropdownMenuItem<String>(
                      value: e,
                      enabled: esPermitido,
                      child: Text(
                        estadoBonito(e) +
                            (esPermitido ? '' : '  (no permitido)'),
                        style: TextStyle(
                          color: esPermitido
                              ? null
                              : theme.disabledColor,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (v) async {
                    if (v == null) return;
                    final esFinalNuevo = v == 'entregada' || v == 'cancelada';
                    if (esFinalNuevo) {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Confirmar ${estadoBonito(v).toLowerCase()}'),
                          content: Text(
                            'La orden pasara a "${estadoBonito(v)}" y no podra modificarse despues. Continuar?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Confirmar'),
                            ),
                          ],
                        ),
                      );
                      if (ok != true) return;
                      setState(() => _estadoActual = v);
                      final vmActual = ref.read(detalleOrdenProvider(widget.orden).notifier);
                      await _guardar(vmActual);
                    } else {
                      setState(() => _estadoActual = v);
                    }
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: (!_hayCambios || state.guardando)
                      ? null
                      : () => _guardar(vm),
                  child: Text(state.guardando ? 'Guardando...' : 'Guardar'),
                ),
                if (_hayCambios)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Hay cambios sin guardar',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ),
              ],
              if (_puedeEditarTrabajo) ...[
                const Divider(height: 32),
                const Text('Registrar mano de obra',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                TextField(
                  controller: _trabajoDescCtrl,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  controller: _trabajoCostoCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Costo'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed:
                      state.guardando ? null : () => _agregarTrabajo(vm),
                  child: const Text('Agregar trabajo'),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    foregroundColor: theme.colorScheme.onTertiary,
                  ),
                  onPressed:
                      state.guardando ? null : () => _agregarRepuesto(vm),
                  icon: const Icon(Icons.build_circle),
                  label: const Text('Añadir repuesto'),
                ),
              ],
              const Divider(height: 32),
              const Text('Trabajos',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              if (state.trabajos.isEmpty)
                const Text('Sin trabajos.')
              else
                ...state.trabajos.map(
                  (t) => Card(
                    child: ListTile(
                      title: Text(t.descripcion),
                      trailing: Text(
                        '\$${t.costoManoDeObra.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              const Text('Repuestos usados',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              if (state.repuestos.isEmpty)
                const Text('Sin repuestos.')
              else
                ...state.repuestos.map(
                  (i) => Card(
                    child: ListTile(
                      title: Text(
                          '${i.repuesto.nombre} (${i.repuesto.codigo})'),
                      subtitle: Text(
                          '${i.detalle.cantidad} x \$${i.detalle.precioUnitario.toStringAsFixed(2)}'),
                      trailing: Text(
                        '\$${(i.detalle.cantidad * i.detalle.precioUnitario).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
