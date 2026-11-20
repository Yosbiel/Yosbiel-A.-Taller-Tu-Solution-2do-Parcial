import 'package:flutter/material.dart';
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

final ordenesAbiertasProvider =
    StreamProvider.autoDispose<List<OrdenesReparacionData>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchOrdenesAbiertas();
});

final todosRepuestosProvider =
    StreamProvider.autoDispose<List<RepuestosData>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchTodosRepuestos();
});

final repuestosStockBajoProvider =
    StreamProvider.autoDispose<List<RepuestosData>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchRepuestosStockBajo();
});

final cargaTrabajoProvider =
    StreamProvider.autoDispose<Map<String, int>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchCargaTrabajoPorTecnico();
});

// Lista reactiva de los 3 tecnicos. La usan los dropdowns.
final tecnicosProvider =
    StreamProvider.autoDispose<List<TecnicosData>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchTecnicos();
});

final historialEquipoProvider = FutureProvider.autoDispose
    .family<List<HistorialOrdenItem>, String>((ref, filtro) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.buscarHistorialPorEquipo(filtro);
});

final historialClienteProvider = FutureProvider.autoDispose
    .family<List<HistorialOrdenItem>, String>((ref, filtro) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.buscarHistorialPorCliente(filtro);
});

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
