import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/daos/talleres_dao.dart';
import '../../data/database/app_database.dart';
import '../../viewmodels/talleres_providers.dart';

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
  List<DetallesOrdenTrabajo> _trabajos = [];
  List<RepuestoUsadoItem> _repuestosUsados = [];
  bool _cargandoDetalles = true;

  @override
  void initState() {
    super.initState();
    _estadoActual = widget.orden.estado;
    _tecnicoCtrl.text = widget.orden.tecnicoAsignado ?? '';
    _cargarDetallesYCosto();
  }

  Future<void> _cargarDetallesYCosto() async {
    final dao = ref.read(talleresDaoProvider);
    final trabajos = await dao.obtenerTrabajosDeOrden(widget.orden.id);
    final repuestos = await dao.obtenerRepuestosDeOrden(widget.orden.id);
    final total = await dao.calcularCostoTotalOrden(widget.orden.id);
    if (mounted) {
      setState(() {
        _trabajos = trabajos;
        _repuestosUsados = repuestos;
        _costoTotal = total;
        _cargandoDetalles = false;
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
        tecnico: _tecnicoCtrl.text.trim(),
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
      await _cargarDetallesYCosto();

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

  Future<void> _confirmarCantidadRepuesto(
    BuildContext parentContext,
    TalleresDao dao,
    RepuestosData rep,
  ) async {
    int cantidad = 1;
    final cantCtrl = TextEditingController(text: '1');

    await showDialog(
      context: parentContext,
      builder: (dlgCtx) => StatefulBuilder(
        builder: (ctx, setDlgState) {
          void sincronizarCantidad(int nueva) {
            if (nueva < 1) nueva = 1;
            if (nueva > rep.existencias) nueva = rep.existencias;
            setDlgState(() {
              cantidad = nueva;
              cantCtrl.text = nueva.toString();
            });
          }

          return AlertDialog(
            title: Text('Cantidad: ${rep.nombre}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Stock disponible: ${rep.existencias} | Precio: \$${rep.precio.toStringAsFixed(2)}'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: cantidad > 1 ? () => sincronizarCantidad(cantidad - 1) : null,
                    ),
                    SizedBox(
                      width: 72,
                      child: TextField(
                        controller: cantCtrl,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Cant.'),
                        onChanged: (val) {
                          final parsed = int.tryParse(val.trim());
                          if (parsed != null && parsed >= 1 && parsed <= rep.existencias) {
                            setDlgState(() => cantidad = parsed);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: cantidad < rep.existencias ? () => sincronizarCantidad(cantidad + 1) : null,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dlgCtx),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final finalCant = int.tryParse(cantCtrl.text.trim()) ?? cantidad;
                  if (finalCant <= 0 || finalCant > rep.existencias) {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(content: Text('Cantidad inválida (máx. ${rep.existencias}).')),
                    );
                    return;
                  }
                  try {
                    await dao.agregarRepuestoAOrden(
                      ordenId: widget.orden.id,
                      repuestoId: rep.id,
                      cantidadUsada: finalCant,
                    );
                    ref.invalidate(todosRepuestosProvider);
                    ref.invalidate(repuestosStockBajoProvider);
                    await _cargarDetallesYCosto();
                    if (dlgCtx.mounted) Navigator.pop(dlgCtx);
                    if (parentContext.mounted) {
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(content: Text('Se agregaron $finalCant x ${rep.nombre}')),
                      );
                    }
                  } catch (e) {
                    if (parentContext.mounted) {
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(content: Text('Error al usar repuesto: $e')),
                      );
                    }
                  }
                },
                child: const Text('Agregar'),
              ),
            ],
          );
        },
      ),
    );

    cantCtrl.dispose();
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
                      subtitle: Text('Stock: ${rep.existencias} - \$${rep.precio.toStringAsFixed(2)}'),
                      trailing: ElevatedButton(
                        onPressed: rep.existencias <= 0
                            ? null
                            : () async {
                                Navigator.pop(ctx);
                                await _confirmarCantidadRepuesto(context, dao, rep);
                              },
                        child: const Text('Elegir'),
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
          const SizedBox(height: 16),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            onPressed: () => _mostrarSelectorRepuestos(context, ref),
            icon: const Icon(Icons.build_circle),
            label: const Text('Añadir Repuesto del Almacén'),
          ),
          const Divider(height: 32),

          const Text('Trabajos Registrados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          if (_cargandoDetalles)
            const Center(child: CircularProgressIndicator())
          else if (_trabajos.isEmpty)
            const Text('Aún no hay trabajos registrados en esta orden.')
          else
            ..._trabajos.map(
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

          const Text('Repuestos Utilizados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          if (!_cargandoDetalles)
            if (_repuestosUsados.isEmpty)
              const Text('Aún no se han utilizado repuestos en esta orden.')
            else
              ..._repuestosUsados.map(
                (item) => Card(
                  child: ListTile(
                    title: Text('${item.repuesto.nombre} (${item.repuesto.codigo})'),
                    subtitle: Text(
                      'Cantidad: ${item.detalle.cantidad} x \$${item.detalle.precioUnitario.toStringAsFixed(2)}',
                    ),
                    trailing: Text(
                      '\$${(item.detalle.cantidad * item.detalle.precioUnitario).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
