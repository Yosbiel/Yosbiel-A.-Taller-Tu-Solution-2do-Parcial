// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talleres_dao.dart';

// ignore_for_file: type=lint
mixin _$TalleresDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientesTable get clientes => attachedDatabase.clientes;
  $EquiposTable get equipos => attachedDatabase.equipos;
  $TecnicosTable get tecnicos => attachedDatabase.tecnicos;
  $OrdenesReparacionTable get ordenesReparacion =>
      attachedDatabase.ordenesReparacion;
  $RepuestosTable get repuestos => attachedDatabase.repuestos;
  $DetallesOrdenTrabajosTable get detallesOrdenTrabajos =>
      attachedDatabase.detallesOrdenTrabajos;
  $DetallesOrdenRepuestosTable get detallesOrdenRepuestos =>
      attachedDatabase.detallesOrdenRepuestos;
  TalleresDaoManager get managers => TalleresDaoManager(this);
}

class TalleresDaoManager {
  final _$TalleresDaoMixin _db;
  TalleresDaoManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$EquiposTableTableManager get equipos =>
      $$EquiposTableTableManager(_db.attachedDatabase, _db.equipos);
  $$TecnicosTableTableManager get tecnicos =>
      $$TecnicosTableTableManager(_db.attachedDatabase, _db.tecnicos);
  $$OrdenesReparacionTableTableManager get ordenesReparacion =>
      $$OrdenesReparacionTableTableManager(
          _db.attachedDatabase, _db.ordenesReparacion);
  $$RepuestosTableTableManager get repuestos =>
      $$RepuestosTableTableManager(_db.attachedDatabase, _db.repuestos);
  $$DetallesOrdenTrabajosTableTableManager get detallesOrdenTrabajos =>
      $$DetallesOrdenTrabajosTableTableManager(
          _db.attachedDatabase, _db.detallesOrdenTrabajos);
  $$DetallesOrdenRepuestosTableTableManager get detallesOrdenRepuestos =>
      $$DetallesOrdenRepuestosTableTableManager(
          _db.attachedDatabase, _db.detallesOrdenRepuestos);
}
