import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/daos/talleres_dao.dart';
import '../data/database/app_database.dart';
import 'talleres_providers.dart';

// Estado completo de una orden en pantalla de detalle.
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

// ViewModel de detalle de orden. Un family por ordenId.
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

  // Guarda estado + tecnico. Lanza excepcion para que la pantalla muestre el error.
  Future<void> guardarCambios(String nuevoEstado, String tecnico) async {
    final orden = arg;
    final actual = state.valueOrNull;
    if (actual == null) return;
    state = AsyncData(actual.copyWith(guardando: true));
    try {
      final dao = ref.read(talleresDaoProvider);
      await dao.actualizarEstadoYTecnico(
        orden.id,
        nuevoEstado,
        tecnico: tecnico,
      );
    } finally {
      state = AsyncData((state.valueOrNull ?? actual).copyWith(guardando: false));
    }
  }

  // Agrega un trabajo de mano de obra y recarga el estado.
  Future<void> agregarTrabajo(String descripcion, double costo) async {
    final actual = state.valueOrNull;
    if (actual == null) return;
    state = AsyncData(actual.copyWith(guardando: true));
    try {
      final dao = ref.read(talleresDaoProvider);
      await dao.insertarTrabajo(arg.id, descripcion, costo);
      state = AsyncData(await _cargar(arg).then((s) => s.copyWith(guardando: false)));
    } finally {
      state = AsyncData((state.valueOrNull ?? actual).copyWith(guardando: false));
    }
  }

  // Agrega un repuesto del almacen y recarga el estado.
  Future<void> agregarRepuesto(int repuestoId, int cantidad) async {
    final actual = state.valueOrNull;
    if (actual == null) return;
    state = AsyncData(actual.copyWith(guardando: true));
    try {
      final dao = ref.read(talleresDaoProvider);
      await dao.agregarRepuestoAOrden(
        ordenId: arg.id,
        repuestoId: repuestoId,
        cantidadUsada: cantidad,
      );
      state = AsyncData(await _cargar(arg).then((s) => s.copyWith(guardando: false)));
    } finally {
      state = AsyncData((state.valueOrNull ?? actual).copyWith(guardando: false));
    }
  }
}
