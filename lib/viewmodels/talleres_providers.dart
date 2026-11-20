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

// Ordenes abiertas: reactivo, se actualiza solo cuando cambia la tabla.
final ordenesAbiertasProvider =
    StreamProvider.autoDispose<List<OrdenesReparacionData>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchOrdenesAbiertas();
});

// Repuestos del almacen: reactivo.
final todosRepuestosProvider =
    StreamProvider.autoDispose<List<RepuestosData>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchTodosRepuestos();
});

// Repuestos con stock bajo: reactivo.
final repuestosStockBajoProvider =
    StreamProvider.autoDispose<List<RepuestosData>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchRepuestosStockBajo();
});

// Carga de trabajo por tecnico: reactivo.
final cargaTrabajoProvider =
    StreamProvider.autoDispose<Map<String, int>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchCargaTrabajoPorTecnico();
});

// Historial por equipo: busqueda puntual con filtro (no reactivo).
final historialEquipoProvider = FutureProvider.autoDispose
    .family<List<HistorialOrdenItem>, String>((ref, filtro) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.buscarHistorialPorEquipo(filtro);
});

// Historial por cliente: busqueda puntual con filtro (no reactivo).
final historialClienteProvider = FutureProvider.autoDispose
    .family<List<HistorialOrdenItem>, String>((ref, filtro) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.buscarHistorialPorCliente(filtro);
});

// Modo de tema (claro/oscuro/sistema). Lo usara main.dart en la Parte 3
// y el boton sol/luna en la Parte 4.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
