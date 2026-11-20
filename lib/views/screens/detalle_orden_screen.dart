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
  final _tecnicoCtrl = TextEditingController();
  final _trabajoDescCtrl = TextEditingController();
  final _trabajoCostoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _estadoActual = widget.orden.estado;
    _tecnicoCtrl.text = widget.orden.tecnicoAsignado ?? '';
  }

  @override
  void dispose() {
    _tecnicoCtrl.dispose();
    _trabajoDescCtrl.dispose();
    _trabajoCostoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios(DetalleOrdenViewModel vm) async {
    try {
      await vm.guardarCambios(_estadoActual, _tecnicoCtrl.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orden actualizada correctamente')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  Future<void> _agregarTrabajo(DetalleOrdenViewModel vm) async {
    final descripcion = _trabajoDescCtrl.text.trim();
    final costo =
        double.tryParse(_trabajoCostoCtrl.text.trim().replaceAll(',', '.'));
    if (descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa una descripcion del trabajo.')),
      );
      return;
    }
    if (costo == null || costo <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un costo mayor a 0.')),
      );
      return;
    }
    try {
      await vm.agregarTrabajo(descripcion, costo);
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

  Future<void> _mostrarSelectorRepuestos(
    DetalleOrdenViewModel vm,
  ) async {
    final dao = ref.read(talleresDaoProvider);
    final repuestos = await dao.obtenerTodosRepuestos();
    if (!mounted) return;
    if (repuestos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay repuestos en el almacen.')),
      );
      return;
    }
    final seleccionado = await showDialog<RepuestosData>(
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
                subtitle: Text('Stock: ${r.existencias} | \$${r.precio.toStringAsFixed(2)}'),
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
    if (seleccionado == null || !mounted) return;

    final cantidad = await showDialog<int>(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController(text: '1');
        return AlertDialog(
          title: Text(seleccionado.nombre),
          content: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Cantidad (max ${seleccionado.existencias})',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final n = int.tryParse(ctrl.text.trim());
                if (n == null || n <= 0 || n > seleccionado.existencias) return;
                Navigator.pop(ctx, n);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
    if (cantidad == null || !mounted) return;
    try {
      await vm.agregarRepuesto(seleccionado.id, cantidad);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se agregaron $cantidad x ${seleccionado.nombre}')),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Orden #${widget.orden.id}'),
        actions: const [],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (state) {
          final vm = ref.read(detalleOrdenProvider(widget.orden).notifier);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Falla: ${widget.orden.fallaReportada}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                  color: Colors.green,
                ),
              ),
              const Divider(height: 24),
              TextField(
                controller: _tecnicoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tecnico responsable',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _estadoActual,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: const ['recibida', 'en_reparacion', 'lista', 'entregada', 'cancelada']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _estadoActual = v);
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: state.guardando ? null : () => _guardarCambios(vm),
                child: Text(state.guardando ? 'Guardando...' : 'Guardar cambios'),
              ),
              const Divider(height: 32),
              const Text(
                'Registrar mano de obra',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
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
                onPressed:
                    state.guardando ? null : () => _agregarTrabajo(vm),
                child: const Text('Agregar trabajo'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                onPressed: state.guardando
                    ? null
                    : () => _mostrarSelectorRepuestos(vm),
                icon: const Icon(Icons.build_circle),
                label: const Text('Anadir repuesto'),
              ),
              const Divider(height: 32),
              const Text(
                'Trabajos registrados',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              if (state.trabajos.isEmpty)
                const Text('Aun no hay trabajos.')
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
              const Text(
                'Repuestos utilizados',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              if (state.repuestos.isEmpty)
                const Text('Aun no se han usado repuestos.')
              else
                ...state.repuestos.map(
                  (item) => Card(
                    child: ListTile(
                      title: Text(
                        '${item.repuesto.nombre} (${item.repuesto.codigo})',
                      ),
                      subtitle: Text(
                        '${item.detalle.cantidad} x \$${item.detalle.precioUnitario.toStringAsFixed(2)}',
                      ),
                      trailing: Text(
                        '\$${(item.detalle.cantidad * item.detalle.precioUnitario).toStringAsFixed(2)}',
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
