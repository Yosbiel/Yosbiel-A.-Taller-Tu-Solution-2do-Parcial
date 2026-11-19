import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../viewmodels/talleres_providers.dart';
import 'consultas_screen.dart';

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

  double _costoTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _estadoActual = widget.orden.estado;
    _tecnicoCtrl.text = widget.orden.tecnicoAsignado ?? '';
    _cargarCostoTotal();
  }

  Future<void> _cargarCostoTotal() async {
    final dao = ref.read(talleresDaoProvider);
    final total = await dao.calcularCostoTotalOrden(widget.orden.id);
    if (mounted) {
      setState(() {
        _costoTotal = total;
      });
    }
  }

  @override
  void dispose() {
    _tecnicoCtrl.dispose();
    _trabajoDescCtrl.dispose();
    _trabajoCostoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    try {
      final dao = ref.read(talleresDaoProvider);
      await dao.actualizarEstadoYTecnico(
        widget.orden.id,
        _estadoActual,
        _tecnicoCtrl.text.trim(),
      );
      ref.invalidate(ordenesAbiertasProvider);
      ref.invalidate(cargaTrabajoProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orden actualizada correctamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar orden: $e')),
        );
      }
    }
  }

  Future<void> _agregarTrabajo() async {
    final descripcion = _trabajoDescCtrl.text.trim();
    final costo = double.tryParse(_trabajoCostoCtrl.text.trim().replaceAll(',', '.'));

    if (descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa una descripción del trabajo.')),
      );
      return;
    }

    if (costo == null || costo <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un costo de mano de obra mayor a 0.')),
      );
      return;
    }

    try {
      final dao = ref.read(talleresDaoProvider);
      await dao.insertarTrabajo(widget.orden.id, descripcion, costo);

      _trabajoDescCtrl.clear();
      _trabajoCostoCtrl.clear();
      await _cargarCostoTotal();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mano de obra registrada')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar mano de obra: $e')),
        );
      }
    }
  }

  void _mostrarSelectorRepuestos(BuildContext context, WidgetRef ref) async {
    final dao = ref.read(talleresDaoProvider);
    final repuestos = await dao.obtenerTodosRepuestos();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Seleccionar Repuesto'),
        content: SizedBox(
          width: double.maxFinite,
          child: repuestos.isEmpty
              ? const Text('No hay repuestos en el almacén.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: repuestos.length,
                  itemBuilder: (context, index) {
                    final rep = repuestos[index];
                    return ListTile(
                      title: Text(rep.nombre),
                      subtitle: Text('Stock: ${rep.existencias} - \$${rep.precio}'),
                      trailing: ElevatedButton(
                        onPressed: rep.existencias <= 0
                            ? null
                            : () async {
                                try {
                                  await dao.agregarRepuestoAOrden(
                                    ordenId: widget.orden.id,
                                    repuesto: rep,
                                    cantidadUsada: 1,
                                  );
                                  ref.invalidate(todosRepuestosProvider);
                                  ref.invalidate(repuestosStockBajoProvider);
                                  await _cargarCostoTotal();
                                  if (ctx.mounted) Navigator.pop(ctx);
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error al usar repuesto: $e')),
                                    );
                                  }
                                }
                              },
                        child: const Text('Usar (1)'),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orden #${widget.orden.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Falla reportada: ${widget.orden.fallaReportada}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Costo Total Acumulado: \$${_costoTotal.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const Divider(height: 24),

          TextField(
            controller: _tecnicoCtrl,
            decoration: const InputDecoration(labelText: 'Técnico responsable'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _estadoActual,
            decoration: const InputDecoration(labelText: 'Estado de la orden'),
            items: ['recibida', 'en_reparacion', 'lista', 'entregada', 'cancelada']
                .map((estado) => DropdownMenuItem(value: estado, child: Text(estado)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _estadoActual = val);
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _guardarCambios,
            child: const Text('Guardar Cambios de la Orden'),
          ),
          const Divider(height: 32),

          const Text('Registrar Mano de Obra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          TextField(
            controller: _trabajoDescCtrl,
            decoration: const InputDecoration(labelText: 'Descripción del trabajo realizado'),
          ),
          TextField(
            controller: _trabajoCostoCtrl,
            decoration: const InputDecoration(labelText: 'Costo de mano de obra'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _agregarTrabajo,
            child: const Text('Agregar Trabajo'),
          ),
          const Divider(height: 32),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            onPressed: () => _mostrarSelectorRepuestos(context, ref),
            icon: const Icon(Icons.build_circle),
            label: const Text('Añadir Repuesto del Almacén'),
          ),
        ],
      ),
    );
  }
}
