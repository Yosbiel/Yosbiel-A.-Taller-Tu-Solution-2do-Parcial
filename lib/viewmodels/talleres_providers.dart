import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';
import '../data/daos/talleres_dao.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});

final talleresDaoProvider = Provider<TalleresDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.talleresDao;
});

final ordenesAbiertasProvider = FutureProvider.autoDispose<List<OrdenesReparacionData>>((ref) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.obtenerOrdenesAbiertas();
});

final todosRepuestosProvider = FutureProvider.autoDispose<List<RepuestosData>>((ref) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.obtenerTodosRepuestos();
});

final repuestosStockBajoProvider = FutureProvider.autoDispose<List<RepuestosData>>((ref) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.obtenerRepuestosStockBajo();
});

final cargaTrabajoProvider = FutureProvider.autoDispose>((ref) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.obtenerCargaTrabajoPorTecnico();
});

final historialEquipoProvider =
    FutureProvider.autoDispose.family<List<HistorialOrdenItem>, String>((ref, filtro) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.buscarHistorialPorEquipo(filtro);
});

final historialClienteProvider =
    FutureProvider.autoDispose.family<List<HistorialOrdenItem>, String>((ref, filtro) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.buscarHistorialPorCliente(filtro);
});
