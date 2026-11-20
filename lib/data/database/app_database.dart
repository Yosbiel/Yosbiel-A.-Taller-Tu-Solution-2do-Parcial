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

  // Version 2: se anade la tabla Tecnicos y la columna tecnicoId en ordenes.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      // Primera instalacion: crear todo y sembrar los 3 tecnicos.
      onCreate: (m) async {
        await m.createAll();
        await _seedTecnicos();
      },
      // Migracion v1 -> v2: agregar tabla Tecnicos y recrear ordenes.
      // Como en v1 no hay datos reales, se dropea ordenes_reparacion y se
      // vuelve a crear con la nueva columna tecnicoId. Si hubiera datos
      // reales, habria que migrar el texto tecnicoAsignado a un id.
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.createTable(tecnicos);
          await m.deleteTable('ordenes_reparacion');
          await m.createTable(ordenesReparacion);
          await _seedTecnicos();
        }
      },
    );
  }

  // Inserta los 3 tecnicos fijos del taller.
  Future<void> _seedTecnicos() async {
    const nombres = ['Tecnico 1', 'Tecnico 2', 'Tecnico 3'];
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
