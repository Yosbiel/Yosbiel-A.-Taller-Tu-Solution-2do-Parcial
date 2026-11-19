import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';
import '../data/daos/talleres_dao.dart';

// 1- Proveedor global de la instancia de la base de datos
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});

// 2- Proveedor para acceder al DAO del taller
final talleresDaoProvider = Provider<TalleresDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.talleresDao;
});

// 3- Órdenes abiertas
final ordenesAbiertasProvider = FutureProvider.autoDispose<List<OrdenesReparacionData>>((ref) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.obtenerOrdenesAbiertas();
});

// 4- Todos los repuestos del inventario
final todosRepuestosProvider = FutureProvider.autoDispose<List<RepuestosData>>((ref) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.obtenerTodosRepuestos();
});

// 5- Repuestos con stock bajo
final repuestosStockBajoProvider = FutureProvider.autoDispose<List<RepuestosData>>((ref) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.obtenerRepuestosStockBajo();
});

// 6- Carga de trabajo activa por técnico
final cargaTrabajoProvider = FutureProvider.autoDispose>((ref) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.obtenerCargaTrabajoPorTecnico();
});

// 7- Historial de reparaciones por equipo (serie, marca, modelo o tipo)
final historialEquipoProvider =
    FutureProvider.autoDispose.family<List<HistorialOrdenItem>, String>((ref, filtro) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.buscarHistorialPorEquipo(filtro);
});

// 8- Historial de reparaciones por cliente (nombre o teléfono)
final historialClienteProvider =
    FutureProvider.autoDispose.family<List<HistorialOrdenItem>, String>((ref, filtro) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.buscarHistorialPorCliente(filtro);
});
