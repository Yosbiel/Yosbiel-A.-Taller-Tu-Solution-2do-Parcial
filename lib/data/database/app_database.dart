import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Importamos el archivo de las tablas
import 'app_tables.dart';

// Importamos el DAO que creamos para las consultas del taller
import '../daos/talleres_dao.dart';

// Esta línea le indica a Drift qué archivo generado debe enlazar
part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Clientes,
    Equipos,
    Repuestos,
    OrdenesReparacion,
    DetallesOrdenTrabajos,
    DetallesOrdenRepuestos,
  ],
  daos: [TalleresDao], // <-- Aquí registramos el DAO integrado correctamente
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tu_solution.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
