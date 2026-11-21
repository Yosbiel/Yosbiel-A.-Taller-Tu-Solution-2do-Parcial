import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/database/app_database.dart';
import '../data/daos/talleres_dao.dart';

// Provider que expone una única instancia de la base de datos.
// Se cierra automáticamente cuando la app se destruye.
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});

// Provider para acceder al DAO (capa de datos).
final talleresDaoProvider = Provider<TalleresDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.talleresDao;
});

// Stream con las órdenes que no están entregadas ni canceladas.
final ordenesAbiertasProvider =
    StreamProvider<List<OrdenesReparacionData>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchOrdenesAbiertas();
});

// Stream con todos los repuestos del inventario.
final todosRepuestosProvider =
    StreamProvider.autoDispose<List<RepuestosData>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchTodosRepuestos();
});

// Stream con los repuestos cuyo stock es igual o menor a 3.
final repuestosStockBajoProvider =
    StreamProvider.autoDispose<List<RepuestosData>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchRepuestosStockBajo();
});

// Stream con la carga de trabajo agrupada por técnico.
final cargaTrabajoProvider =
    StreamProvider.autoDispose<Map<String, int>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchCargaTrabajoPorTecnico();
});

// Stream con la lista de los 3 técnicos del taller.
final tecnicosProvider =
    StreamProvider.autoDispose<List<TecnicosData>>((ref) {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchTecnicos();
});

// Búsqueda reactiva del historial por equipo.
final historialEquipoProvider = FutureProvider.autoDispose
    .family<List<HistorialOrdenItem>, String>((ref, filtro) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.buscarHistorialPorEquipo(filtro);
});

// Búsqueda reactiva del historial por cliente.
final historialClienteProvider = FutureProvider.autoDispose
    .family<List<HistorialOrdenItem>, String>((ref, filtro) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.buscarHistorialPorCliente(filtro);
});

// --- Persistencia del tema (Claro / Oscuro / Sistema) ---
const _kThemeKey = 'theme_mode';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _cargar();
  }

  // Carga la preferencia guardada al iniciar la app.
  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final guardado = prefs.getString(_kThemeKey);
    if (guardado == 'dark') {
      state = ThemeMode.dark;
    } else if (guardado == 'light') {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.system;
    }
  }

  // Guarda la preferencia cada vez que el usuario cambia el tema.
  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    if (mode == ThemeMode.dark) {
      await prefs.setString(_kThemeKey, 'dark');
    } else if (mode == ThemeMode.light) {
      await prefs.setString(_kThemeKey, 'light');
    } else {
      await prefs.remove(_kThemeKey);
    }
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

// Historial completo (sin filtros) con datos de cliente y equipo.
final historialCompletoProvider =
    FutureProvider.autoDispose<List<HistorialOrdenItem>>((ref) async {
  final dao = ref.watch(talleresDaoProvider);
  return await dao.obtenerHistorialCompleto();
});
