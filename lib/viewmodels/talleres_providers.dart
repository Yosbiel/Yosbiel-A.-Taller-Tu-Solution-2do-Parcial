import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    StreamProvider<List<OrdenesReparacionData>>((ref) {
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

// Tema persistente en SharedPreferences.
const _kThemeKey = 'theme_mode';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _cargar();
  }

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

final historialCompletoProvider =
    FutureProvider.autoDispose<List<HistorialOrdenItem>>((ref) async {
  final dao = ref.watch(talleresDaoProvider);
  return dao.watchTodasLasOrdenes();
});
