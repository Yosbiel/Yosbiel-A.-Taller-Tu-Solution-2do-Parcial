// GENERATED CODE - HAND-CRAFTED COMPATIBLE STUB FOR DRIFT

part of 'app_database.dart';

class Cliente extends DataClass implements Insertable<Cliente> {
  final int id;
  final String nombre;
  final String telefono;

  const Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['telefono'] = Variable<String>(telefono);
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: Value(telefono),
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, telefono);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> telefono;

  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
  });

  ClientesCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String telefono,
  })  : nombre = Value(nombre),
        telefono = Value(telefono);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (nombre.present) map['nombre'] = Variable<String>(nombre.value);
    if (telefono.present) map['telefono'] = Variable<String>(telefono.value);
    return map;
  }
}

class $ClientesTable extends Clientes with TableInfo<Clientes, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $ClientesTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,

  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
      'telefono', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns => [id, nombre, telefono];

  @override
  String get aliasedName => _alias ?? 'clientes';

  @override
  String get actualTableName => 'clientes';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      telefono: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefono'])!,
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Equipo extends DataClass implements Insertable<Equipo> {
  final int id;
  final int clienteId;
  final String tipo;
  final String marca;
  final String modelo;
  final String numeroSerie;

  const Equipo({
    required this.id,
    required this.clienteId,
    required this.tipo,
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return {
      'id': Variable<int>(id),
      'cliente_id': Variable<int>(clienteId),
      'tipo': Variable<String>(tipo),
      'marca': Variable<String>(marca),
      'modelo': Variable<String>(modelo),
      'numero_serie': Variable<String>(numeroSerie),
    };
  }

  @override
  int get hashCode =>
      Object.hash(id, clienteId, tipo, marca, modelo, numeroSerie);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Equipo &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.tipo == this.tipo &&
          other.marca == this.marca &&
          other.modelo == this.modelo &&
          other.numeroSerie == this.numeroSerie);
}

class EquiposCompanion extends UpdateCompanion<Equipo> {
  final Value<int> id;
  final Value<int> clienteId;
  final Value<String> tipo;
  final Value<String> marca;
  final Value<String> modelo;
  final Value<String> numeroSerie;

  const EquiposCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.marca = const Value.absent(),
    this.modelo = const Value.absent(),
    this.numeroSerie = const Value.absent(),
  });

  EquiposCompanion.insert({
    this.id = const Value.absent(),
    required int clienteId,
    required String tipo,
    required String marca,
    required String modelo,
    required String numeroSerie,
  })  : clienteId = Value(clienteId),
        tipo = Value(tipo),
        marca = Value(marca),
        modelo = Value(modelo),
        numeroSerie = Value(numeroSerie);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (clienteId.present) map['cliente_id'] = Variable<int>(clienteId.value);
    if (tipo.present) map['tipo'] = Variable<String>(tipo.value);
    if (marca.present) map['marca'] = Variable<String>(marca.value);
    if (modelo.present) map['modelo'] = Variable<String>(modelo.value);
    if (numeroSerie.present) {
      map['numero_serie'] = Variable<String>(numeroSerie.value);
    }
    return map;
  }
}

class $EquiposTable extends Equipos with TableInfo<Equipos, Equipo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $EquiposTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,

  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
      'cliente_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);

  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
      'marca', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  late final GeneratedColumn<String> modelo = GeneratedColumn<String>(
      'modelo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  late final GeneratedColumn<String> numeroSerie = GeneratedColumn<String>(
      'numero_serie', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns =>
      [id, clienteId, tipo, marca, modelo, numeroSerie];

  @override
  String get aliasedName => _alias ?? 'equipos';

  @override
  String get actualTableName => 'equipos';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Equipo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Equipo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      clienteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cliente_id'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      marca: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}marca'])!,
      modelo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}modelo'])!,
      numeroSerie: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero_serie'])!,
    );
  }

  @override
  $EquiposTable createAlias(String alias) {
    return $EquiposTable(attachedDatabase, alias);
  }
}

class Repuesto extends DataClass implements Insertable<Repuesto> {
  final int id;
  final String codigo;
  final String nombre;
  final double precio;
  final int existencias;

  const Repuesto({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.precio,
    required this.existencias,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return {
      'id': Variable<int>(id),
      'codigo': Variable<String>(codigo),
      'nombre': Variable<String>(nombre),
      'precio': Variable<double>(precio),
      'existencias': Variable<int>(existencias),
    };
  }

  @override
  int get hashCode => Object.hash(id, codigo, nombre, precio, existencias);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Repuesto &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.nombre == this.nombre &&
          other.precio == this.precio &&
          other.existencias == this.existencias);
}

typedef RepuestosData = Repuesto;

class RepuestosCompanion extends UpdateCompanion<Repuesto> {
  final Value<int> id;
  final Value<String> codigo;
  final Value<String> nombre;
  final Value<double> precio;
  final Value<int> existencias;

  const RepuestosCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.nombre = const Value.absent(),
    this.precio = const Value.absent(),
    this.existencias = const Value.absent(),
  });

  RepuestosCompanion.insert({
    this.id = const Value.absent(),
    required String codigo,
    required String nombre,
    required double precio,
    required int existencias,
  })  : codigo = Value(codigo),
        nombre = Value(nombre),
        precio = Value(precio),
        existencias = Value(existencias);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (codigo.present) map['codigo'] = Variable<String>(codigo.value);
    if (nombre.present) map['nombre'] = Variable<String>(nombre.value);
    if (precio.present) map['precio'] = Variable<double>(precio.value);
    if (existencias.present) {
      map['existencias'] = Variable<int>(existencias.value);
    }
    return map;
  }
}

class $RepuestosTable extends Repuestos with TableInfo<Repuestos, Repuesto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $RepuestosTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,

  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
      'codigo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
      'precio', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);

  late final GeneratedColumn<int> existencias = GeneratedColumn<int>(
      'existencias', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns => [id, codigo, nombre, precio, existencias];

  @override
  String get aliasedName => _alias ?? 'repuestos';

  @override
  String get actualTableName => 'repuestos';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Repuesto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Repuesto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      codigo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      precio: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precio'])!,
      existencias: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}existencias'])!,
    );
  }

  @override
  $RepuestosTable createAlias(String alias) {
    return $RepuestosTable(attachedDatabase, alias);
  }
}

class OrdenesReparacionData extends DataClass
    implements Insertable<OrdenesReparacionData> {
  final int id;
  final int equipoId;
  final String fallaReportada;
  final String estado;
  final String? tecnicoAsignado;
  final DateTime fechaCreacion;

  const OrdenesReparacionData({
    required this.id,
    required this.equipoId,
    required this.fallaReportada,
    required this.estado,
    this.tecnicoAsignado,
    required this.fechaCreacion,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['equipo_id'] = Variable<int>(equipoId);
    map['falla_reportada'] = Variable<String>(fallaReportada);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || tecnicoAsignado != null) {
      map['tecnico_asignado'] = Variable<String>(tecnicoAsignado);
    }
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    return map;
  }

  @override
  int get hashCode => Object.hash(
      id, equipoId, fallaReportada, estado, tecnicoAsignado, fechaCreacion);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdenesReparacionData &&
          other.id == this.id &&
          other.equipoId == this.equipoId &&
          other.fallaReportada == this.fallaReportada &&
          other.estado == this.estado &&
          other.tecnicoAsignado == this.tecnicoAsignado &&
          other.fechaCreacion == this.fechaCreacion);
}

class OrdenesReparacionCompanion extends UpdateCompanion<OrdenesReparacionData> {
  final Value<int> id;
  final Value<int> equipoId;
  final Value<String> fallaReportada;
  final Value<String> estado;
  final Value<String?> tecnicoAsignado;
  final Value<DateTime> fechaCreacion;

  const OrdenesReparacionCompanion({
    this.id = const Value.absent(),
    this.equipoId = const Value.absent(),
    this.fallaReportada = const Value.absent(),
    this.estado = const Value.absent(),
    this.tecnicoAsignado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
  });

  OrdenesReparacionCompanion.insert({
    this.id = const Value.absent(),
    required int equipoId,
    required String fallaReportada,
    required String estado,
    this.tecnicoAsignado = const Value.absent(),
    required DateTime fechaCreacion,
  })  : equipoId = Value(equipoId),
        fallaReportada = Value(fallaReportada),
        estado = Value(estado),
        fechaCreacion = Value(fechaCreacion);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (equipoId.present) map['equipo_id'] = Variable<int>(equipoId.value);
    if (fallaReportada.present) {
      map['falla_reportada'] = Variable<String>(fallaReportada.value);
    }
    if (estado.present) map['estado'] = Variable<String>(estado.value);
    if (tecnicoAsignado.present) {
      map['tecnico_asignado'] = Variable<String>(tecnicoAsignado.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    return map;
  }
}

class $OrdenesReparacionTable extends OrdenesReparacion
    with TableInfo<OrdenesReparacion, OrdenesReparacionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $OrdenesReparacionTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,

  late final GeneratedColumn<int> equipoId = GeneratedColumn<int>(
      'equipo_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);

  late final GeneratedColumn<String> fallaReportada = GeneratedColumn<String>(
      'falla_reportada', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  late final GeneratedColumn<String> tecnicoAsignado = GeneratedColumn<String>(
      'tecnico_asignado', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);

  late final GeneratedColumn<DateTime> fechaCreacion = GeneratedColumn<DateTime>(
      'fecha_creacion', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns =>
      [id, equipoId, fallaReportada, estado, tecnicoAsignado, fechaCreacion];

  @override
  String get aliasedName => _alias ?? 'ordenes_reparacion';

  @override
  String get actualTableName => 'ordenes_reparacion';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  OrdenesReparacionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdenesReparacionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      equipoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}equipo_id'])!,
      fallaReportada: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}falla_reportada'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      tecnicoAsignado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tecnico_asignado']),
      fechaCreacion: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_creacion'])!,
    );
  }

  @override
  $OrdenesReparacionTable createAlias(String alias) {
    return $OrdenesReparacionTable(attachedDatabase, alias);
  }
}

class DetallesOrdenTrabajo extends DataClass
    implements Insertable<DetallesOrdenTrabajo> {
  final int id;
  final int ordenId;
  final String descripcion;
  final double costoManoDeObra;

  const DetallesOrdenTrabajo({
    required this.id,
    required this.ordenId,
    required this.descripcion,
    required this.costoManoDeObra,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return {
      'id': Variable<int>(id),
      'orden_id': Variable<int>(ordenId),
      'descripcion': Variable<String>(descripcion),
      'costo_mano_de_obra': Variable<double>(costoManoDeObra),
    };
  }

  @override
  int get hashCode => Object.hash(id, ordenId, descripcion, costoManoDeObra);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DetallesOrdenTrabajo &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.descripcion == this.descripcion &&
          other.costoManoDeObra == this.costoManoDeObra);
}

class DetallesOrdenTrabajosCompanion
    extends UpdateCompanion<DetallesOrdenTrabajo> {
  final Value<int> id;
  final Value<int> ordenId;
  final Value<String> descripcion;
  final Value<double> costoManoDeObra;

  const DetallesOrdenTrabajosCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.costoManoDeObra = const Value.absent(),
  });

  DetallesOrdenTrabajosCompanion.insert({
    this.id = const Value.absent(),
    required int ordenId,
    required String descripcion,
    required double costoManoDeObra,
  })  : ordenId = Value(ordenId),
        descripcion = Value(descripcion),
        costoManoDeObra = Value(costoManoDeObra);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (ordenId.present) map['orden_id'] = Variable<int>(ordenId.value);
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (costoManoDeObra.present) {
      map['costo_mano_de_obra'] = Variable<double>(costoManoDeObra.value);
    }
    return map;
  }
}

class $DetallesOrdenTrabajosTable extends DetallesOrdenTrabajos
    with TableInfo<DetallesOrdenTrabajos, DetallesOrdenTrabajo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $DetallesOrdenTrabajosTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,

  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
      'orden_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);

  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);

  late final GeneratedColumn<double> costoManoDeObra = GeneratedColumn<double>(
      'costo_mano_de_obra', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns =>
      [id, ordenId, descripcion, costoManoDeObra];

  @override
  String get aliasedName => _alias ?? 'detalles_orden_trabajos';

  @override
  String get actualTableName => 'detalles_orden_trabajos';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  DetallesOrdenTrabajo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DetallesOrdenTrabajo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ordenId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orden_id'])!,
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion'])!,
      costoManoDeObra: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}costo_mano_de_obra'])!,
    );
  }

  @override
  $DetallesOrdenTrabajosTable createAlias(String alias) {
    return $DetallesOrdenTrabajosTable(attachedDatabase, alias);
  }
}

class DetallesOrdenRepuesto extends DataClass
    implements Insertable<DetallesOrdenRepuesto> {
  final int id;
  final int ordenId;
  final int repuestoId;
  final int cantidad;
  final double precioUnitario;

  const DetallesOrdenRepuesto({
    required this.id,
    required this.ordenId,
    required this.repuestoId,
    required this.cantidad,
    required this.precioUnitario,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return {
      'id': Variable<int>(id),
      'orden_id': Variable<int>(ordenId),
      'repuesto_id': Variable<int>(repuestoId),
      'cantidad': Variable<int>(cantidad),
      'precio_unitario': Variable<double>(precioUnitario),
    };
  }

  @override
  int get hashCode =>
      Object.hash(id, ordenId, repuestoId, cantidad, precioUnitario);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DetallesOrdenRepuesto &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.repuestoId == this.repuestoId &&
          other.cantidad == this.cantidad &&
          other.precioUnitario == this.precioUnitario);
}

class DetallesOrdenRepuestosCompanion
    extends UpdateCompanion<DetallesOrdenRepuesto> {
  final Value<int> id;
  final Value<int> ordenId;
  final Value<int> repuestoId;
  final Value<int> cantidad;
  final Value<double> precioUnitario;

  const DetallesOrdenRepuestosCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.repuestoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
  });

  DetallesOrdenRepuestosCompanion.insert({
    this.id = const Value.absent(),
    required int ordenId,
    required int repuestoId,
    required int cantidad,
    required double precioUnitario,
  })  : ordenId = Value(ordenId),
        repuestoId = Value(repuestoId),
        cantidad = Value(cantidad),
        precioUnitario = Value(precioUnitario);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (ordenId.present) map['orden_id'] = Variable<int>(ordenId.value);
    if (repuestoId.present) {
      map['repuesto_id'] = Variable<int>(repuestoId.value);
    }
    if (cantidad.present) map['cantidad'] = Variable<int>(cantidad.value);
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    return map;
  }
}

class $DetallesOrdenRepuestosTable extends DetallesOrdenRepuestos
    with TableInfo<DetallesOrdenRepuestos, DetallesOrdenRepuesto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $DetallesOrdenRepuestosTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,

  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
      'orden_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);

  late final GeneratedColumn<int> repuestoId = GeneratedColumn<int>(
      'repuesto_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);

  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);

  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
      'precio_unitario', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);

  @override
  List<GeneratedColumn> get $columns =>
      [id, ordenId, repuestoId, cantidad, precioUnitario];

  @override
  String get aliasedName => _alias ?? 'detalles_orden_repuestos';

  @override
  String get actualTableName => 'detalles_orden_repuestos';

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  DetallesOrdenRepuesto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DetallesOrdenRepuesto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ordenId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orden_id'])!,
      repuestoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repuesto_id'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cantidad'])!,
      precioUnitario: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}precio_unitario'])!,
    );
  }

  @override
  $DetallesOrdenRepuestosTable createAlias(String alias) {
    return $DetallesOrdenRepuestosTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);

  late final $ClientesTable clientes = $ClientesTable(this);
  late final $EquiposTable equipos = $EquiposTable(this);
  late final $RepuestosTable repuestos = $RepuestosTable(this);
  late final $OrdenesReparacionTable ordenesReparacion =
      $OrdenesReparacionTable(this);
  late final $DetallesOrdenTrabajosTable detallesOrdenTrabajos =
      $DetallesOrdenTrabajosTable(this);
  late final $DetallesOrdenRepuestosTable detallesOrdenRepuestos =
      $DetallesOrdenRepuestosTable(this);

  late final TalleresDao talleresDao = TalleresDao(this as AppDatabase);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        clientes,
        equipos,
        repuestos,
        ordenesReparacion,
        detallesOrdenTrabajos,
        detallesOrdenRepuestos,
      ];
}
