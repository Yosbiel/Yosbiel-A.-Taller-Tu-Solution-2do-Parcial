import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/daos/talleres_dao.dart';
import '../data/database/app_database.dart';
import 'talleres_providers.dart';

// Estado que representa la pantalla de Detalle de Orden.
class DetalleOrdenState {
  final List<DetallesOrdenTrabajo> trabajos;
  final List<RepuestoUsadoItem> repuestos;
  final double costoTotal;
  final bool guardando;

  const DetalleOrdenState({
    required this.trabajos,
    required this.repuestos,
    required this.costoTotal,
    required this.guardando,
  });

  DetalleOrdenState copyWith({
    List<DetallesOrdenTrabajo>? trabajos,
    List<RepuestoUsadoItem>? repuestos,
    double? costoTotal,
    bool? guardando,
  }) {
    return DetalleOrdenState(
      trabajos: trabajos ?? this.trabajos,
      repuestos: repuestos ?? this.repuestos,
      costoTotal: costoTotal ?? this.costoTotal,
      guardando: guardando ?? this.guardando,
    );
  }
}

// Provider que crea un ViewModel por cada orden. Usamos autoDispose para
// liberar memoria cuando se sale de la pantalla.
final detalleOrdenProvider = AsyncNotifierProvider.autoDispose
    .family<DetalleOrdenViewModel, DetalleOrdenState, OrdenesReparacionData>(
  DetalleOrdenViewModel.new,
);

class DetalleOrdenViewModel
    extends AutoDisposeFamilyAsyncNotifier<DetalleOrdenState, OrdenesReparacionData> {
  
  @override
  Future<DetalleOrdenState> build(OrdenesReparacionData arg) async {
    return _cargar(arg);
  }

  // Carga los datos iniciales de la orden desde la base de datos.
  Future<DetalleOrdenState> _cargar(OrdenesReparacionData orden) async {
    final dao = ref.read(talleresDaoProvider);
    final trabajos = await dao.obtenerTrabajosDeOrden(orden.id);
    final repuestos = await dao.obtenerRepuestosDeOrden(orden.id);
    final total = await dao.calcularCostoTotalOrden(orden.id);
    
    return DetalleOrdenState(
      trabajos: trabajos,
      repuestos: repuestos,
      costoTotal: total,
      guardando: false,
    );
  }

  // Método auxiliar que maneja el estado de "guardando" durante las acciones
  // asíncronas. El bloque finally asegura que el spinner se apague y los
  // datos se recarguen, incluso si la operación falla.
  Future<void> _ejecutarConEstado(Future<void> Function() accion) async {
    final actual = state.valueOrNull;
    if (actual == null) return;

    state = AsyncData(actual.copyWith(guardando: true));
    try {
      await accion();
    } finally {
      state = AsyncData(await _cargar(arg));
    }
  }

  Future<void> guardarCambios(String nuevoEstado, int? tecnicoId) async {
    await _ejecutarConEstado(() async {
      final dao = ref.read(talleresDaoProvider);
      await dao.actualizarEstadoYTecnico(arg.id, nuevoEstado, tecnicoId: tecnicoId);
    });
  }

  Future<void> agregarTrabajo(String descripcion, double costo) async {
    await _ejecutarConEstado(() async {
      final dao = ref.read(talleresDaoProvider);
      await dao.insertarTrabajo(arg.id, descripcion, costo);
    });
  }

  Future<void> agregarRepuesto(int repuestoId, int cantidad) async {
    await _ejecutarConEstado(() async {
      final dao = ref.read(talleresDaoProvider);
      await dao.agregarRepuestoAOrden(
        ordenId: arg.id,
        repuestoId: repuestoId,
        cantidadUsada: cantidad,
      );
    });
  }

  // La lógica de liberar la orden se movió aquí para que la vista
  // no tenga que comunicarse directamente con el DAO.
  Future<void> liberarOrden() async {
    await _ejecutarConEstado(() async {
      final dao = ref.read(talleresDaoProvider);
      await dao.liberarOrden(arg.id);
    });
  }
}
