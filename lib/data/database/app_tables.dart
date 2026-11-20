import 'package:drift/drift.dart';

// Clientes del taller.
class Clientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get telefono => text()();
}

// Tecnicos del taller. Son 3 fijos, se siembran en la migracion v2.
@DataClassName('TecnicosData')
class Tecnicos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().unique()();
}

// Equipos que llegan al taller.
class Equipos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clienteId =>
      integer().references(Clientes, #id, onDelete: KeyAction.cascade)();
  TextColumn get tipo => text()();
  TextColumn get marca => text()();
  TextColumn get modelo => text()();
  TextColumn get numeroSerie => text()();
}

// Repuestos del almacen.
@DataClassName('RepuestosData')
class Repuestos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text().unique()();
  TextColumn get nombre => text()();
  RealColumn get precio => real()();
  IntColumn get existencias => integer()();
}

// Ordenes de reparacion.
// tecnicoId: FK nullable a Tecnicos. Null = orden sin tomar.
@DataClassName('OrdenesReparacionData')
class OrdenesReparacion extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get equipoId =>
      integer().references(Equipos, #id, onDelete: KeyAction.cascade)();
  TextColumn get fallaReportada => text()();
  TextColumn get estado => text()();
  IntColumn get tecnicoId => integer().nullable().references(Tecnicos, #id)();
  DateTimeColumn get fechaCreacion => dateTime()();
}

// Mano de obra por orden.
class DetallesOrdenTrabajos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId =>
      integer().references(OrdenesReparacion, #id, onDelete: KeyAction.cascade)();
  TextColumn get descripcion => text()();
  RealColumn get costoManoDeObra => real()();
}

// Repuestos usados por orden.
class DetallesOrdenRepuestos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId =>
      integer().references(OrdenesReparacion, #id, onDelete: KeyAction.cascade)();
  IntColumn get repuestoId => integer().references(Repuestos, #id)();
  IntColumn get cantidad => integer()();
  RealColumn get precioUnitario => real()();
}
