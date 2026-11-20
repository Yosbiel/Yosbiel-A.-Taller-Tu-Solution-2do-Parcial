import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'app_tables.dart';
import '../daos/talleres_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Clientes,
    Tecnicos,
    Equipos,
    Repuestos,
    OrdenesReparacion,
    DetallesOrdenTrabajos,
    DetallesOrdenRepuestos,
  ],
  daos: [TalleresDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // v3: nombres reales de tecnicos.
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        await _seedTecnicos();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.createTable(tecnicos);
          await m.deleteTable('ordenes_reparacion');
          await m.createTable(ordenesReparacion);
          await _seedTecnicos();
        }
        if (from < 3) {
          // v3: borrar los tecnicos viejos ("Tecnico 1..3") y sembrar los reales.
          await delete(tecnicos).go();
          await _seedTecnicos();
        }
      },
    );
  }

  Future<void> _seedTecnicos() async {
    const nombres = ['Carlos', 'Ana', 'Luis'];
    for (final n in nombres) {
      await into(tecnicos).insert(TecnicosCompanion.insert(nombre: n));
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tu_solution.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
