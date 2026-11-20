import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/daos/talleres_dao.dart';
import '../../data/database/app_database.dart';
import '../../viewmodels/detalle_orden_viewmodel.dart';
import '../../viewmodels/talleres_providers.dart';
import '../widgets/estado_pildora.dart';

class DetalleOrdenScreen extends ConsumerStatefulWidget {
  final OrdenesReparacionData orden;
  const DetalleOrdenScreen({Key? key, required this.orden}) : super(key: key);

  @override
  ConsumerState<DetalleOrdenScreen> createState() => _DetalleOrdenScreenState();
}

class _DetalleOrdenScreenState extends ConsumerState<DetalleOrdenScreen> {
  late String _estadoActual;
  int? _tecnicoId;
  final _trabajoDescCtrl = TextEditingController();
  final _trabajoCostoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _estadoActual = widget.orden.estado;
    _tecnicoId = widget.orden.tecnicoId;
  }

  @override
  void dispose() {
    _trabajoDescCtrl.dispose();
    _trabajoCostoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar(DetalleOrdenViewModel vm) async {
    try {
      await vm.guardarCambios(_estadoActual, _tecnicoId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orden actualizada')),
      );
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
        const SnackBar(content: Text('Descripcion y costo validos requeridos.')),
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
        const SnackBar(content: Text('Sin repuestos en almacen.')),
      );
      return;
    }
    final sel = await showDialog<RepuestosData>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Seleccionar repuesto'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: repuestos.length,
            itemBuilder: (_, i) {
              final r = repuestos[i];
              return ListTile(
                title: Text(r.nombre),
                subtitle: Text(
                    'Stock: ${r.existencias} | \$${r.precio.toStringAsFixed(2)}'),
                enabled: r.existencias > 0,
                onTap: r.existencias > 0 ? () => Navigator.pop(ctx, r) : null,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
    if (sel == null || !mounted) return;
    final cant = await showDialog<int>(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController(text: '1');
        return AlertDialog(
          title: Text(sel.nombre),
          content: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Cantidad (max ${sel.existencias})'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final n = int.tryParse(ctrl.text.trim());
                if (n == null || n <= 0 || n > sel.existencias) return;
                Navigator.pop(ctx, n);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
    if (cant == null || !mounted) return;
    try {
      await vm.agregarRepuesto(sel.id, cant);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se agregaron $cant x ${sel.nombre}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(detalleOrdenProvider(widget.orden));
    final tecnicosAsync = ref.watch(tecnicosProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Orden #${widget.orden.id}')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (state) {
          final vm = ref.read(detalleOrdenProvider(widget.orden).notifier);
          final tecnicos = tecnicosAsync.valueOrNull ?? const [];
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
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const Divider(height: 24),
              DropdownButtonFormField<int?>(
                value: _tecnicoId,
                decoration:
                    const InputDecoration(labelText: 'Tecnico responsable'),
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
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _estadoActual,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: const [
                  'recibida',
                  'en_reparacion',
                  'lista',
                  'entregada',
                  'cancelada'
                ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _estadoActual = v);
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: state.guardando ? null : () => _guardar(vm),
                child: Text(state.guardando ? 'Guardando...' : 'Guardar'),
              ),
              const Divider(height: 32),
              const Text('Registrar mano de obra',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              TextField(
                controller: _trabajoDescCtrl,
                decoration: const InputDecoration(labelText: 'Descripcion'),
              ),
              TextField(
                controller: _trabajoCostoCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Costo'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: state.guardando ? null : () => _agregarTrabajo(vm),
                child: const Text('Agregar trabajo'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                onPressed:
                    state.guardando ? null : () => _agregarRepuesto(vm),
                icon: const Icon(Icons.build_circle),
                label: const Text('Anadir repuesto'),
              ),
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
