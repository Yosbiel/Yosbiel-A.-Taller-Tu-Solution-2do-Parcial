import 'package:drift/drift.dart';

// 1. Tabla de Clientes
class Clientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get telefono => text()();
}

// 2. Tabla de Equipos
class Equipos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clienteId => integer().references(Clientes, #id, onDelete: KeyAction.cascade)();
  TextColumn get tipo => text()(); // Celular, Tablet, Laptop
  TextColumn get marca => text()();
  TextColumn get modelo => text()();
  TextColumn get numeroSerie => text()();
}

// 3. Tabla de Repuestos
@DataClassName('RepuestosData')
class Repuestos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text().unique()();
  TextColumn get nombre => text()();
  RealColumn get precio => real()();
  IntColumn get existencias => integer()();
}

// 4. Tabla de Órdenes de Reparación
@DataClassName('OrdenesReparacionData')
class OrdenesReparacion extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get equipoId => integer().references(Equipos, #id, onDelete: KeyAction.cascade)();
  TextColumn get fallaReportada => text()();
  TextColumn get estado => text()(); // recibida, en_reparacion, lista, entregada, cancelada
  TextColumn get tecnicoAsignado => text().nullable()();
  DateTimeColumn get fechaCreacion => dateTime()();
}

// 5. Tabla de Trabajos / Mano de Obra por Orden
class DetallesOrdenTrabajos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesReparacion, #id, onDelete: KeyAction.cascade)();
  TextColumn get descripcion => text()();
  RealColumn get costoManoDeObra => real()();
}

// 6. Tabla de Repuestos utilizados por Orden
class DetallesOrdenRepuestos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesReparacion, #id, onDelete: KeyAction.cascade)();
  IntColumn get repuestoId => integer().references(Repuestos, #id)();
  IntColumn get cantidad => integer()();
  RealColumn get precioUnitario => real()();
}
