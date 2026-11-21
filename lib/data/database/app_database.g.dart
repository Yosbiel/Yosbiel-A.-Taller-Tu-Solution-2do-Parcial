// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _telefonoMeta =
      const VerificationMeta('telefono');
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
      'telefono', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nombre, telefono];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(Insertable<Cliente> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(_telefonoMeta,
          telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta));
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    return context;
  }

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

class Cliente extends DataClass implements Insertable<Cliente> {
  final int id;
  final String nombre;
  final String telefono;
  const Cliente(
      {required this.id, required this.nombre, required this.telefono});
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

  factory Cliente.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      telefono: serializer.fromJson<String>(json['telefono']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'telefono': serializer.toJson<String>(telefono),
    };
  }

  Cliente copyWith({int? id, String? nombre, String? telefono}) => Cliente(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        telefono: telefono ?? this.telefono,
      );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
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
  static Insertable<Cliente> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? telefono,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
    });
  }

  ClientesCompanion copyWith(
      {Value<int>? id, Value<String>? nombre, Value<String>? telefono}) {
    return ClientesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono')
          ..write(')'))
        .toString();
  }
}

class $TecnicosTable extends Tecnicos
    with TableInfo<$TecnicosTable, TecnicosData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TecnicosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tecnicos';
  @override
  VerificationContext validateIntegrity(Insertable<TecnicosData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TecnicosData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TecnicosData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
    );
  }

  @override
  $TecnicosTable createAlias(String alias) {
    return $TecnicosTable(attachedDatabase, alias);
  }
}

class TecnicosData extends DataClass implements Insertable<TecnicosData> {
  final int id;
  final String nombre;
  const TecnicosData({required this.id, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  TecnicosCompanion toCompanion(bool nullToAbsent) {
    return TecnicosCompanion(
      id: Value(id),
      nombre: Value(nombre),
    );
  }

  factory TecnicosData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TecnicosData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  TecnicosData copyWith({int? id, String? nombre}) => TecnicosData(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
      );
  TecnicosData copyWithCompanion(TecnicosCompanion data) {
    return TecnicosData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TecnicosData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TecnicosData &&
          other.id == this.id &&
          other.nombre == this.nombre);
}

class TecnicosCompanion extends UpdateCompanion<TecnicosData> {
  final Value<int> id;
  final Value<String> nombre;
  const TecnicosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  TecnicosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<TecnicosData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  TecnicosCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return TecnicosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TecnicosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $EquiposTable extends Equipos with TableInfo<$EquiposTable, Equipo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquiposTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _clienteIdMeta =
      const VerificationMeta('clienteId');
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
      'cliente_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES clientes (id) ON DELETE CASCADE'));
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
      'marca', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  @override
  late final GeneratedColumn<String> modelo = GeneratedColumn<String>(
      'modelo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numeroSerieMeta =
      const VerificationMeta('numeroSerie');
  @override
  late final GeneratedColumn<String> numeroSerie = GeneratedColumn<String>(
      'numero_serie', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, clienteId, tipo, marca, modelo, numeroSerie];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipos';
  @override
  VerificationContext validateIntegrity(Insertable<Equipo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(_clienteIdMeta,
          clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta));
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('marca')) {
      context.handle(
          _marcaMeta, marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta));
    } else if (isInserting) {
      context.missing(_marcaMeta);
    }
    if (data.containsKey('modelo')) {
      context.handle(_modeloMeta,
          modelo.isAcceptableOrUnknown(data['modelo']!, _modeloMeta));
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('numero_serie')) {
      context.handle(
          _numeroSerieMeta,
          numeroSerie.isAcceptableOrUnknown(
              data['numero_serie']!, _numeroSerieMeta));
    } else if (isInserting) {
      context.missing(_numeroSerieMeta);
    }
    return context;
  }

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

class Equipo extends DataClass implements Insertable<Equipo> {
  final int id;
  final int clienteId;
  final String tipo;
  final String marca;
  final String modelo;
  final String numeroSerie;
  const Equipo(
      {required this.id,
      required this.clienteId,
      required this.tipo,
      required this.marca,
      required this.modelo,
      required this.numeroSerie});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cliente_id'] = Variable<int>(clienteId);
    map['tipo'] = Variable<String>(tipo);
    map['marca'] = Variable<String>(marca);
    map['modelo'] = Variable<String>(modelo);
    map['numero_serie'] = Variable<String>(numeroSerie);
    return map;
  }

  EquiposCompanion toCompanion(bool nullToAbsent) {
    return EquiposCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      tipo: Value(tipo),
      marca: Value(marca),
      modelo: Value(modelo),
      numeroSerie: Value(numeroSerie),
    );
  }

  factory Equipo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Equipo(
      id: serializer.fromJson<int>(json['id']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      marca: serializer.fromJson<String>(json['marca']),
      modelo: serializer.fromJson<String>(json['modelo']),
      numeroSerie: serializer.fromJson<String>(json['numeroSerie']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clienteId': serializer.toJson<int>(clienteId),
      'tipo': serializer.toJson<String>(tipo),
      'marca': serializer.toJson<String>(marca),
      'modelo': serializer.toJson<String>(modelo),
      'numeroSerie': serializer.toJson<String>(numeroSerie),
    };
  }

  Equipo copyWith(
          {int? id,
          int? clienteId,
          String? tipo,
          String? marca,
          String? modelo,
          String? numeroSerie}) =>
      Equipo(
        id: id ?? this.id,
        clienteId: clienteId ?? this.clienteId,
        tipo: tipo ?? this.tipo,
        marca: marca ?? this.marca,
        modelo: modelo ?? this.modelo,
        numeroSerie: numeroSerie ?? this.numeroSerie,
      );
  Equipo copyWithCompanion(EquiposCompanion data) {
    return Equipo(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      marca: data.marca.present ? data.marca.value : this.marca,
      modelo: data.modelo.present ? data.modelo.value : this.modelo,
      numeroSerie:
          data.numeroSerie.present ? data.numeroSerie.value : this.numeroSerie,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Equipo(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('tipo: $tipo, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('numeroSerie: $numeroSerie')
          ..write(')'))
        .toString();
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
  static Insertable<Equipo> custom({
    Expression<int>? id,
    Expression<int>? clienteId,
    Expression<String>? tipo,
    Expression<String>? marca,
    Expression<String>? modelo,
    Expression<String>? numeroSerie,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (tipo != null) 'tipo': tipo,
      if (marca != null) 'marca': marca,
      if (modelo != null) 'modelo': modelo,
      if (numeroSerie != null) 'numero_serie': numeroSerie,
    });
  }

  EquiposCompanion copyWith(
      {Value<int>? id,
      Value<int>? clienteId,
      Value<String>? tipo,
      Value<String>? marca,
      Value<String>? modelo,
      Value<String>? numeroSerie}) {
    return EquiposCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      tipo: tipo ?? this.tipo,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      numeroSerie: numeroSerie ?? this.numeroSerie,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    if (numeroSerie.present) {
      map['numero_serie'] = Variable<String>(numeroSerie.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquiposCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('tipo: $tipo, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('numeroSerie: $numeroSerie')
          ..write(')'))
        .toString();
  }
}

class $RepuestosTable extends Repuestos
    with TableInfo<$RepuestosTable, RepuestosData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepuestosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
      'codigo', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
      'precio', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _existenciasMeta =
      const VerificationMeta('existencias');
  @override
  late final GeneratedColumn<int> existencias = GeneratedColumn<int>(
      'existencias', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, codigo, nombre, precio, existencias];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repuestos';
  @override
  VerificationContext validateIntegrity(Insertable<RepuestosData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('codigo')) {
      context.handle(_codigoMeta,
          codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta));
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('precio')) {
      context.handle(_precioMeta,
          precio.isAcceptableOrUnknown(data['precio']!, _precioMeta));
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('existencias')) {
      context.handle(
          _existenciasMeta,
          existencias.isAcceptableOrUnknown(
              data['existencias']!, _existenciasMeta));
    } else if (isInserting) {
      context.missing(_existenciasMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepuestosData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepuestosData(
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

class RepuestosData extends DataClass implements Insertable<RepuestosData> {
  final int id;
  final String codigo;
  final String nombre;
  final double precio;
  final int existencias;
  const RepuestosData(
      {required this.id,
      required this.codigo,
      required this.nombre,
      required this.precio,
      required this.existencias});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo'] = Variable<String>(codigo);
    map['nombre'] = Variable<String>(nombre);
    map['precio'] = Variable<double>(precio);
    map['existencias'] = Variable<int>(existencias);
    return map;
  }

  RepuestosCompanion toCompanion(bool nullToAbsent) {
    return RepuestosCompanion(
      id: Value(id),
      codigo: Value(codigo),
      nombre: Value(nombre),
      precio: Value(precio),
      existencias: Value(existencias),
    );
  }

  factory RepuestosData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepuestosData(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      nombre: serializer.fromJson<String>(json['nombre']),
      precio: serializer.fromJson<double>(json['precio']),
      existencias: serializer.fromJson<int>(json['existencias']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String>(codigo),
      'nombre': serializer.toJson<String>(nombre),
      'precio': serializer.toJson<double>(precio),
      'existencias': serializer.toJson<int>(existencias),
    };
  }

  RepuestosData copyWith(
          {int? id,
          String? codigo,
          String? nombre,
          double? precio,
          int? existencias}) =>
      RepuestosData(
        id: id ?? this.id,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
        precio: precio ?? this.precio,
        existencias: existencias ?? this.existencias,
      );
  RepuestosData copyWithCompanion(RepuestosCompanion data) {
    return RepuestosData(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      precio: data.precio.present ? data.precio.value : this.precio,
      existencias:
          data.existencias.present ? data.existencias.value : this.existencias,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepuestosData(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nombre: $nombre, ')
          ..write('precio: $precio, ')
          ..write('existencias: $existencias')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, codigo, nombre, precio, existencias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepuestosData &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.nombre == this.nombre &&
          other.precio == this.precio &&
          other.existencias == this.existencias);
}

class RepuestosCompanion extends UpdateCompanion<RepuestosData> {
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
  static Insertable<RepuestosData> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<String>? nombre,
    Expression<double>? precio,
    Expression<int>? existencias,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (nombre != null) 'nombre': nombre,
      if (precio != null) 'precio': precio,
      if (existencias != null) 'existencias': existencias,
    });
  }

  RepuestosCompanion copyWith(
      {Value<int>? id,
      Value<String>? codigo,
      Value<String>? nombre,
      Value<double>? precio,
      Value<int>? existencias}) {
    return RepuestosCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      existencias: existencias ?? this.existencias,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (existencias.present) {
      map['existencias'] = Variable<int>(existencias.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepuestosCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nombre: $nombre, ')
          ..write('precio: $precio, ')
          ..write('existencias: $existencias')
          ..write(')'))
        .toString();
  }
}

class $OrdenesReparacionTable extends OrdenesReparacion
    with TableInfo<$OrdenesReparacionTable, OrdenesReparacionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdenesReparacionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _equipoIdMeta =
      const VerificationMeta('equipoId');
  @override
  late final GeneratedColumn<int> equipoId = GeneratedColumn<int>(
      'equipo_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES equipos (id) ON DELETE CASCADE'));
  static const VerificationMeta _fallaReportadaMeta =
      const VerificationMeta('fallaReportada');
  @override
  late final GeneratedColumn<String> fallaReportada = GeneratedColumn<String>(
      'falla_reportada', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tecnicoIdMeta =
      const VerificationMeta('tecnicoId');
  @override
  late final GeneratedColumn<int> tecnicoId = GeneratedColumn<int>(
      'tecnico_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tecnicos (id)'));
  static const VerificationMeta _fechaCreacionMeta =
      const VerificationMeta('fechaCreacion');
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>('fecha_creacion', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, equipoId, fallaReportada, estado, tecnicoId, fechaCreacion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ordenes_reparacion';
  @override
  VerificationContext validateIntegrity(
      Insertable<OrdenesReparacionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('equipo_id')) {
      context.handle(_equipoIdMeta,
          equipoId.isAcceptableOrUnknown(data['equipo_id']!, _equipoIdMeta));
    } else if (isInserting) {
      context.missing(_equipoIdMeta);
    }
    if (data.containsKey('falla_reportada')) {
      context.handle(
          _fallaReportadaMeta,
          fallaReportada.isAcceptableOrUnknown(
              data['falla_reportada']!, _fallaReportadaMeta));
    } else if (isInserting) {
      context.missing(_fallaReportadaMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('tecnico_id')) {
      context.handle(_tecnicoIdMeta,
          tecnicoId.isAcceptableOrUnknown(data['tecnico_id']!, _tecnicoIdMeta));
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
          _fechaCreacionMeta,
          fechaCreacion.isAcceptableOrUnknown(
              data['fecha_creacion']!, _fechaCreacionMeta));
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    return context;
  }

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
      fallaReportada: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}falla_reportada'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      tecnicoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tecnico_id']),
      fechaCreacion: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_creacion'])!,
    );
  }

  @override
  $OrdenesReparacionTable createAlias(String alias) {
    return $OrdenesReparacionTable(attachedDatabase, alias);
  }
}

class OrdenesReparacionData extends DataClass
    implements Insertable<OrdenesReparacionData> {
  final int id;
  final int equipoId;
  final String fallaReportada;
  final String estado;
  final int? tecnicoId;
  final DateTime fechaCreacion;
  const OrdenesReparacionData(
      {required this.id,
      required this.equipoId,
      required this.fallaReportada,
      required this.estado,
      this.tecnicoId,
      required this.fechaCreacion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['equipo_id'] = Variable<int>(equipoId);
    map['falla_reportada'] = Variable<String>(fallaReportada);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || tecnicoId != null) {
      map['tecnico_id'] = Variable<int>(tecnicoId);
    }
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    return map;
  }

  OrdenesReparacionCompanion toCompanion(bool nullToAbsent) {
    return OrdenesReparacionCompanion(
      id: Value(id),
      equipoId: Value(equipoId),
      fallaReportada: Value(fallaReportada),
      estado: Value(estado),
      tecnicoId: tecnicoId == null && nullToAbsent
          ? const Value.absent()
          : Value(tecnicoId),
      fechaCreacion: Value(fechaCreacion),
    );
  }

  factory OrdenesReparacionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdenesReparacionData(
      id: serializer.fromJson<int>(json['id']),
      equipoId: serializer.fromJson<int>(json['equipoId']),
      fallaReportada: serializer.fromJson<String>(json['fallaReportada']),
      estado: serializer.fromJson<String>(json['estado']),
      tecnicoId: serializer.fromJson<int?>(json['tecnicoId']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'equipoId': serializer.toJson<int>(equipoId),
      'fallaReportada': serializer.toJson<String>(fallaReportada),
      'estado': serializer.toJson<String>(estado),
      'tecnicoId': serializer.toJson<int?>(tecnicoId),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
    };
  }

  OrdenesReparacionData copyWith(
          {int? id,
          int? equipoId,
          String? fallaReportada,
          String? estado,
          Value<int?> tecnicoId = const Value.absent(),
          DateTime? fechaCreacion}) =>
      OrdenesReparacionData(
        id: id ?? this.id,
        equipoId: equipoId ?? this.equipoId,
        fallaReportada: fallaReportada ?? this.fallaReportada,
        estado: estado ?? this.estado,
        tecnicoId: tecnicoId.present ? tecnicoId.value : this.tecnicoId,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      );
  OrdenesReparacionData copyWithCompanion(OrdenesReparacionCompanion data) {
    return OrdenesReparacionData(
      id: data.id.present ? data.id.value : this.id,
      equipoId: data.equipoId.present ? data.equipoId.value : this.equipoId,
      fallaReportada: data.fallaReportada.present
          ? data.fallaReportada.value
          : this.fallaReportada,
      estado: data.estado.present ? data.estado.value : this.estado,
      tecnicoId: data.tecnicoId.present ? data.tecnicoId.value : this.tecnicoId,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdenesReparacionData(')
          ..write('id: $id, ')
          ..write('equipoId: $equipoId, ')
          ..write('fallaReportada: $fallaReportada, ')
          ..write('estado: $estado, ')
          ..write('tecnicoId: $tecnicoId, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, equipoId, fallaReportada, estado, tecnicoId, fechaCreacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdenesReparacionData &&
          other.id == this.id &&
          other.equipoId == this.equipoId &&
          other.fallaReportada == this.fallaReportada &&
          other.estado == this.estado &&
          other.tecnicoId == this.tecnicoId &&
          other.fechaCreacion == this.fechaCreacion);
}

class OrdenesReparacionCompanion
    extends UpdateCompanion<OrdenesReparacionData> {
  final Value<int> id;
  final Value<int> equipoId;
  final Value<String> fallaReportada;
  final Value<String> estado;
  final Value<int?> tecnicoId;
  final Value<DateTime> fechaCreacion;
  const OrdenesReparacionCompanion({
    this.id = const Value.absent(),
    this.equipoId = const Value.absent(),
    this.fallaReportada = const Value.absent(),
    this.estado = const Value.absent(),
    this.tecnicoId = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
  });
  OrdenesReparacionCompanion.insert({
    this.id = const Value.absent(),
    required int equipoId,
    required String fallaReportada,
    required String estado,
    this.tecnicoId = const Value.absent(),
    required DateTime fechaCreacion,
  })  : equipoId = Value(equipoId),
        fallaReportada = Value(fallaReportada),
        estado = Value(estado),
        fechaCreacion = Value(fechaCreacion);
  static Insertable<OrdenesReparacionData> custom({
    Expression<int>? id,
    Expression<int>? equipoId,
    Expression<String>? fallaReportada,
    Expression<String>? estado,
    Expression<int>? tecnicoId,
    Expression<DateTime>? fechaCreacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (equipoId != null) 'equipo_id': equipoId,
      if (fallaReportada != null) 'falla_reportada': fallaReportada,
      if (estado != null) 'estado': estado,
      if (tecnicoId != null) 'tecnico_id': tecnicoId,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
    });
  }

  OrdenesReparacionCompanion copyWith(
      {Value<int>? id,
      Value<int>? equipoId,
      Value<String>? fallaReportada,
      Value<String>? estado,
      Value<int?>? tecnicoId,
      Value<DateTime>? fechaCreacion}) {
    return OrdenesReparacionCompanion(
      id: id ?? this.id,
      equipoId: equipoId ?? this.equipoId,
      fallaReportada: fallaReportada ?? this.fallaReportada,
      estado: estado ?? this.estado,
      tecnicoId: tecnicoId ?? this.tecnicoId,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (equipoId.present) {
      map['equipo_id'] = Variable<int>(equipoId.value);
    }
    if (fallaReportada.present) {
      map['falla_reportada'] = Variable<String>(fallaReportada.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (tecnicoId.present) {
      map['tecnico_id'] = Variable<int>(tecnicoId.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdenesReparacionCompanion(')
          ..write('id: $id, ')
          ..write('equipoId: $equipoId, ')
          ..write('fallaReportada: $fallaReportada, ')
          ..write('estado: $estado, ')
          ..write('tecnicoId: $tecnicoId, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }
}

class $DetallesOrdenTrabajosTable extends DetallesOrdenTrabajos
    with TableInfo<$DetallesOrdenTrabajosTable, DetallesOrdenTrabajo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DetallesOrdenTrabajosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ordenIdMeta =
      const VerificationMeta('ordenId');
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
      'orden_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES ordenes_reparacion (id) ON DELETE CASCADE'));
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _costoManoDeObraMeta =
      const VerificationMeta('costoManoDeObra');
  @override
  late final GeneratedColumn<double> costoManoDeObra = GeneratedColumn<double>(
      'costo_mano_de_obra', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, ordenId, descripcion, costoManoDeObra];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'detalles_orden_trabajos';
  @override
  VerificationContext validateIntegrity(
      Insertable<DetallesOrdenTrabajo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orden_id')) {
      context.handle(_ordenIdMeta,
          ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta));
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('costo_mano_de_obra')) {
      context.handle(
          _costoManoDeObraMeta,
          costoManoDeObra.isAcceptableOrUnknown(
              data['costo_mano_de_obra']!, _costoManoDeObraMeta));
    } else if (isInserting) {
      context.missing(_costoManoDeObraMeta);
    }
    return context;
  }

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

class DetallesOrdenTrabajo extends DataClass
    implements Insertable<DetallesOrdenTrabajo> {
  final int id;
  final int ordenId;
  final String descripcion;
  final double costoManoDeObra;
  const DetallesOrdenTrabajo(
      {required this.id,
      required this.ordenId,
      required this.descripcion,
      required this.costoManoDeObra});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orden_id'] = Variable<int>(ordenId);
    map['descripcion'] = Variable<String>(descripcion);
    map['costo_mano_de_obra'] = Variable<double>(costoManoDeObra);
    return map;
  }

  DetallesOrdenTrabajosCompanion toCompanion(bool nullToAbsent) {
    return DetallesOrdenTrabajosCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      descripcion: Value(descripcion),
      costoManoDeObra: Value(costoManoDeObra),
    );
  }

  factory DetallesOrdenTrabajo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DetallesOrdenTrabajo(
      id: serializer.fromJson<int>(json['id']),
      ordenId: serializer.fromJson<int>(json['ordenId']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      costoManoDeObra: serializer.fromJson<double>(json['costoManoDeObra']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordenId': serializer.toJson<int>(ordenId),
      'descripcion': serializer.toJson<String>(descripcion),
      'costoManoDeObra': serializer.toJson<double>(costoManoDeObra),
    };
  }

  DetallesOrdenTrabajo copyWith(
          {int? id,
          int? ordenId,
          String? descripcion,
          double? costoManoDeObra}) =>
      DetallesOrdenTrabajo(
        id: id ?? this.id,
        ordenId: ordenId ?? this.ordenId,
        descripcion: descripcion ?? this.descripcion,
        costoManoDeObra: costoManoDeObra ?? this.costoManoDeObra,
      );
  DetallesOrdenTrabajo copyWithCompanion(DetallesOrdenTrabajosCompanion data) {
    return DetallesOrdenTrabajo(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      costoManoDeObra: data.costoManoDeObra.present
          ? data.costoManoDeObra.value
          : this.costoManoDeObra,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DetallesOrdenTrabajo(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('descripcion: $descripcion, ')
          ..write('costoManoDeObra: $costoManoDeObra')
          ..write(')'))
        .toString();
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
  static Insertable<DetallesOrdenTrabajo> custom({
    Expression<int>? id,
    Expression<int>? ordenId,
    Expression<String>? descripcion,
    Expression<double>? costoManoDeObra,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (descripcion != null) 'descripcion': descripcion,
      if (costoManoDeObra != null) 'costo_mano_de_obra': costoManoDeObra,
    });
  }

  DetallesOrdenTrabajosCompanion copyWith(
      {Value<int>? id,
      Value<int>? ordenId,
      Value<String>? descripcion,
      Value<double>? costoManoDeObra}) {
    return DetallesOrdenTrabajosCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      descripcion: descripcion ?? this.descripcion,
      costoManoDeObra: costoManoDeObra ?? this.costoManoDeObra,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (costoManoDeObra.present) {
      map['costo_mano_de_obra'] = Variable<double>(costoManoDeObra.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DetallesOrdenTrabajosCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('descripcion: $descripcion, ')
          ..write('costoManoDeObra: $costoManoDeObra')
          ..write(')'))
        .toString();
  }
}

class $DetallesOrdenRepuestosTable extends DetallesOrdenRepuestos
    with TableInfo<$DetallesOrdenRepuestosTable, DetallesOrdenRepuesto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DetallesOrdenRepuestosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ordenIdMeta =
      const VerificationMeta('ordenId');
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
      'orden_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES ordenes_reparacion (id) ON DELETE CASCADE'));
  static const VerificationMeta _repuestoIdMeta =
      const VerificationMeta('repuestoId');
  @override
  late final GeneratedColumn<int> repuestoId = GeneratedColumn<int>(
      'repuesto_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES repuestos (id)'));
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _precioUnitarioMeta =
      const VerificationMeta('precioUnitario');
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
      'precio_unitario', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, ordenId, repuestoId, cantidad, precioUnitario];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'detalles_orden_repuestos';
  @override
  VerificationContext validateIntegrity(
      Insertable<DetallesOrdenRepuesto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orden_id')) {
      context.handle(_ordenIdMeta,
          ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta));
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('repuesto_id')) {
      context.handle(
          _repuestoIdMeta,
          repuestoId.isAcceptableOrUnknown(
              data['repuesto_id']!, _repuestoIdMeta));
    } else if (isInserting) {
      context.missing(_repuestoIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
          _precioUnitarioMeta,
          precioUnitario.isAcceptableOrUnknown(
              data['precio_unitario']!, _precioUnitarioMeta));
    } else if (isInserting) {
      context.missing(_precioUnitarioMeta);
    }
    return context;
  }

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

class DetallesOrdenRepuesto extends DataClass
    implements Insertable<DetallesOrdenRepuesto> {
  final int id;
  final int ordenId;
  final int repuestoId;
  final int cantidad;
  final double precioUnitario;
  const DetallesOrdenRepuesto(
      {required this.id,
      required this.ordenId,
      required this.repuestoId,
      required this.cantidad,
      required this.precioUnitario});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orden_id'] = Variable<int>(ordenId);
    map['repuesto_id'] = Variable<int>(repuestoId);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    return map;
  }

  DetallesOrdenRepuestosCompanion toCompanion(bool nullToAbsent) {
    return DetallesOrdenRepuestosCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      repuestoId: Value(repuestoId),
      cantidad: Value(cantidad),
      precioUnitario: Value(precioUnitario),
    );
  }

  factory DetallesOrdenRepuesto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DetallesOrdenRepuesto(
      id: serializer.fromJson<int>(json['id']),
      ordenId: serializer.fromJson<int>(json['ordenId']),
      repuestoId: serializer.fromJson<int>(json['repuestoId']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordenId': serializer.toJson<int>(ordenId),
      'repuestoId': serializer.toJson<int>(repuestoId),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
    };
  }

  DetallesOrdenRepuesto copyWith(
          {int? id,
          int? ordenId,
          int? repuestoId,
          int? cantidad,
          double? precioUnitario}) =>
      DetallesOrdenRepuesto(
        id: id ?? this.id,
        ordenId: ordenId ?? this.ordenId,
        repuestoId: repuestoId ?? this.repuestoId,
        cantidad: cantidad ?? this.cantidad,
        precioUnitario: precioUnitario ?? this.precioUnitario,
      );
  DetallesOrdenRepuesto copyWithCompanion(
      DetallesOrdenRepuestosCompanion data) {
    return DetallesOrdenRepuesto(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      repuestoId:
          data.repuestoId.present ? data.repuestoId.value : this.repuestoId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DetallesOrdenRepuesto(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('repuestoId: $repuestoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario')
          ..write(')'))
        .toString();
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
  static Insertable<DetallesOrdenRepuesto> custom({
    Expression<int>? id,
    Expression<int>? ordenId,
    Expression<int>? repuestoId,
    Expression<int>? cantidad,
    Expression<double>? precioUnitario,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (repuestoId != null) 'repuesto_id': repuestoId,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
    });
  }

  DetallesOrdenRepuestosCompanion copyWith(
      {Value<int>? id,
      Value<int>? ordenId,
      Value<int>? repuestoId,
      Value<int>? cantidad,
      Value<double>? precioUnitario}) {
    return DetallesOrdenRepuestosCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      repuestoId: repuestoId ?? this.repuestoId,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (repuestoId.present) {
      map['repuesto_id'] = Variable<int>(repuestoId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DetallesOrdenRepuestosCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('repuestoId: $repuestoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $TecnicosTable tecnicos = $TecnicosTable(this);
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
        tecnicos,
        equipos,
        repuestos,
        ordenesReparacion,
        detallesOrdenTrabajos,
        detallesOrdenRepuestos
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('clientes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('equipos', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('equipos',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('ordenes_reparacion', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('ordenes_reparacion',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('detalles_orden_trabajos', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('ordenes_reparacion',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('detalles_orden_repuestos', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ClientesTableCreateCompanionBuilder = ClientesCompanion Function({
  Value<int> id,
  required String nombre,
  required String telefono,
});
typedef $$ClientesTableUpdateCompanionBuilder = ClientesCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> telefono,
});

final class $$ClientesTableReferences
    extends BaseReferences<_$AppDatabase, $ClientesTable, Cliente> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EquiposTable, List<Equipo>> _equiposRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.equipos,
          aliasName: 'clientes__id__equipos__cliente_id');

  $$EquiposTableProcessedTableManager get equiposRefs {
    final manager = $$EquiposTableTableManager($_db, $_db.equipos)
        .filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_equiposRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnFilters(column));

  Expression<bool> equiposRefs(
      Expression<bool> Function($$EquiposTableFilterComposer f) f) {
    final $$EquiposTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.equipos,
        getReferencedColumn: (t) => t.clienteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EquiposTableFilterComposer(
              $db: $db,
              $table: $db.equipos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnOrderings(column));
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  Expression<T> equiposRefs<T extends Object>(
      Expression<T> Function($$EquiposTableAnnotationComposer a) f) {
    final $$EquiposTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.equipos,
        getReferencedColumn: (t) => t.clienteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EquiposTableAnnotationComposer(
              $db: $db,
              $table: $db.equipos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClientesTable,
    Cliente,
    $$ClientesTableFilterComposer,
    $$ClientesTableOrderingComposer,
    $$ClientesTableAnnotationComposer,
    $$ClientesTableCreateCompanionBuilder,
    $$ClientesTableUpdateCompanionBuilder,
    (Cliente, $$ClientesTableReferences),
    Cliente,
    PrefetchHooks Function({bool equiposRefs})> {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String> telefono = const Value.absent(),
          }) =>
              ClientesCompanion(
            id: id,
            nombre: nombre,
            telefono: telefono,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            required String telefono,
          }) =>
              ClientesCompanion.insert(
            id: id,
            nombre: nombre,
            telefono: telefono,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ClientesTable, Cliente>(table),
                    $$ClientesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({equiposRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (equiposRefs) db.equipos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (equiposRefs)
                    await $_getPrefetchedDataByColumns<Cliente, $ClientesTable,
                            Equipo, $EquiposTable>(
                        currentTable: table,
                        referencedTable:
                            $$ClientesTableReferences._equiposRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClientesTableReferences(db, table, p0)
                                .equiposRefs,
                        currentColumn: 'id',
                        referencedColumn: 'cliente_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ClientesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClientesTable,
    Cliente,
    $$ClientesTableFilterComposer,
    $$ClientesTableOrderingComposer,
    $$ClientesTableAnnotationComposer,
    $$ClientesTableCreateCompanionBuilder,
    $$ClientesTableUpdateCompanionBuilder,
    (Cliente, $$ClientesTableReferences),
    Cliente,
    PrefetchHooks Function({bool equiposRefs})>;
typedef $$TecnicosTableCreateCompanionBuilder = TecnicosCompanion Function({
  Value<int> id,
  required String nombre,
});
typedef $$TecnicosTableUpdateCompanionBuilder = TecnicosCompanion Function({
  Value<int> id,
  Value<String> nombre,
});

final class $$TecnicosTableReferences
    extends BaseReferences<_$AppDatabase, $TecnicosTable, TecnicosData> {
  $$TecnicosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrdenesReparacionTable,
      List<OrdenesReparacionData>> _ordenesReparacionRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.ordenesReparacion,
          aliasName: 'tecnicos__id__ordenes_reparacion__tecnico_id');

  $$OrdenesReparacionTableProcessedTableManager get ordenesReparacionRefs {
    final manager =
        $$OrdenesReparacionTableTableManager($_db, $_db.ordenesReparacion)
            .filter((f) => f.tecnicoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_ordenesReparacionRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TecnicosTableFilterComposer
    extends Composer<_$AppDatabase, $TecnicosTable> {
  $$TecnicosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  Expression<bool> ordenesReparacionRefs(
      Expression<bool> Function($$OrdenesReparacionTableFilterComposer f) f) {
    final $$OrdenesReparacionTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ordenesReparacion,
        getReferencedColumn: (t) => t.tecnicoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesReparacionTableFilterComposer(
              $db: $db,
              $table: $db.ordenesReparacion,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TecnicosTableOrderingComposer
    extends Composer<_$AppDatabase, $TecnicosTable> {
  $$TecnicosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));
}

class $$TecnicosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TecnicosTable> {
  $$TecnicosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  Expression<T> ordenesReparacionRefs<T extends Object>(
      Expression<T> Function($$OrdenesReparacionTableAnnotationComposer a) f) {
    final $$OrdenesReparacionTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.ordenesReparacion,
            getReferencedColumn: (t) => t.tecnicoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OrdenesReparacionTableAnnotationComposer(
                  $db: $db,
                  $table: $db.ordenesReparacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$TecnicosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TecnicosTable,
    TecnicosData,
    $$TecnicosTableFilterComposer,
    $$TecnicosTableOrderingComposer,
    $$TecnicosTableAnnotationComposer,
    $$TecnicosTableCreateCompanionBuilder,
    $$TecnicosTableUpdateCompanionBuilder,
    (TecnicosData, $$TecnicosTableReferences),
    TecnicosData,
    PrefetchHooks Function({bool ordenesReparacionRefs})> {
  $$TecnicosTableTableManager(_$AppDatabase db, $TecnicosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TecnicosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TecnicosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TecnicosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
          }) =>
              TecnicosCompanion(
            id: id,
            nombre: nombre,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
          }) =>
              TecnicosCompanion.insert(
            id: id,
            nombre: nombre,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$TecnicosTable, TecnicosData>(table),
                    $$TecnicosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ordenesReparacionRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ordenesReparacionRefs) db.ordenesReparacion
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordenesReparacionRefs)
                    await $_getPrefetchedDataByColumns<
                            TecnicosData,
                            $TecnicosTable,
                            OrdenesReparacionData,
                            $OrdenesReparacionTable>(
                        currentTable: table,
                        referencedTable: $$TecnicosTableReferences
                            ._ordenesReparacionRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TecnicosTableReferences(db, table, p0)
                                .ordenesReparacionRefs,
                        currentColumn: 'id',
                        referencedColumn: 'tecnico_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TecnicosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TecnicosTable,
    TecnicosData,
    $$TecnicosTableFilterComposer,
    $$TecnicosTableOrderingComposer,
    $$TecnicosTableAnnotationComposer,
    $$TecnicosTableCreateCompanionBuilder,
    $$TecnicosTableUpdateCompanionBuilder,
    (TecnicosData, $$TecnicosTableReferences),
    TecnicosData,
    PrefetchHooks Function({bool ordenesReparacionRefs})>;
typedef $$EquiposTableCreateCompanionBuilder = EquiposCompanion Function({
  Value<int> id,
  required int clienteId,
  required String tipo,
  required String marca,
  required String modelo,
  required String numeroSerie,
});
typedef $$EquiposTableUpdateCompanionBuilder = EquiposCompanion Function({
  Value<int> id,
  Value<int> clienteId,
  Value<String> tipo,
  Value<String> marca,
  Value<String> modelo,
  Value<String> numeroSerie,
});

final class $$EquiposTableReferences
    extends BaseReferences<_$AppDatabase, $EquiposTable, Equipo> {
  $$EquiposTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias('equipos__cliente_id__clientes__id');

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $$ClientesTableTableManager($_db, $_db.clientes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$OrdenesReparacionTable,
      List<OrdenesReparacionData>> _ordenesReparacionRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.ordenesReparacion,
          aliasName: 'equipos__id__ordenes_reparacion__equipo_id');

  $$OrdenesReparacionTableProcessedTableManager get ordenesReparacionRefs {
    final manager =
        $$OrdenesReparacionTableTableManager($_db, $_db.ordenesReparacion)
            .filter((f) => f.equipoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_ordenesReparacionRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EquiposTableFilterComposer
    extends Composer<_$AppDatabase, $EquiposTable> {
  $$EquiposTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marca => $composableBuilder(
      column: $table.marca, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelo => $composableBuilder(
      column: $table.modelo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numeroSerie => $composableBuilder(
      column: $table.numeroSerie, builder: (column) => ColumnFilters(column));

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clienteId,
        referencedTable: $db.clientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientesTableFilterComposer(
              $db: $db,
              $table: $db.clientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> ordenesReparacionRefs(
      Expression<bool> Function($$OrdenesReparacionTableFilterComposer f) f) {
    final $$OrdenesReparacionTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ordenesReparacion,
        getReferencedColumn: (t) => t.equipoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesReparacionTableFilterComposer(
              $db: $db,
              $table: $db.ordenesReparacion,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EquiposTableOrderingComposer
    extends Composer<_$AppDatabase, $EquiposTable> {
  $$EquiposTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marca => $composableBuilder(
      column: $table.marca, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelo => $composableBuilder(
      column: $table.modelo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numeroSerie => $composableBuilder(
      column: $table.numeroSerie, builder: (column) => ColumnOrderings(column));

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clienteId,
        referencedTable: $db.clientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientesTableOrderingComposer(
              $db: $db,
              $table: $db.clientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EquiposTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquiposTable> {
  $$EquiposTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<String> get modelo =>
      $composableBuilder(column: $table.modelo, builder: (column) => column);

  GeneratedColumn<String> get numeroSerie => $composableBuilder(
      column: $table.numeroSerie, builder: (column) => column);

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clienteId,
        referencedTable: $db.clientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientesTableAnnotationComposer(
              $db: $db,
              $table: $db.clientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> ordenesReparacionRefs<T extends Object>(
      Expression<T> Function($$OrdenesReparacionTableAnnotationComposer a) f) {
    final $$OrdenesReparacionTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.ordenesReparacion,
            getReferencedColumn: (t) => t.equipoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OrdenesReparacionTableAnnotationComposer(
                  $db: $db,
                  $table: $db.ordenesReparacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$EquiposTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EquiposTable,
    Equipo,
    $$EquiposTableFilterComposer,
    $$EquiposTableOrderingComposer,
    $$EquiposTableAnnotationComposer,
    $$EquiposTableCreateCompanionBuilder,
    $$EquiposTableUpdateCompanionBuilder,
    (Equipo, $$EquiposTableReferences),
    Equipo,
    PrefetchHooks Function({bool clienteId, bool ordenesReparacionRefs})> {
  $$EquiposTableTableManager(_$AppDatabase db, $EquiposTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquiposTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquiposTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquiposTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> clienteId = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<String> marca = const Value.absent(),
            Value<String> modelo = const Value.absent(),
            Value<String> numeroSerie = const Value.absent(),
          }) =>
              EquiposCompanion(
            id: id,
            clienteId: clienteId,
            tipo: tipo,
            marca: marca,
            modelo: modelo,
            numeroSerie: numeroSerie,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int clienteId,
            required String tipo,
            required String marca,
            required String modelo,
            required String numeroSerie,
          }) =>
              EquiposCompanion.insert(
            id: id,
            clienteId: clienteId,
            tipo: tipo,
            marca: marca,
            modelo: modelo,
            numeroSerie: numeroSerie,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$EquiposTable, Equipo>(table),
                    $$EquiposTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {clienteId = false, ordenesReparacionRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ordenesReparacionRefs) db.ordenesReparacion
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (clienteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.clienteId,
                    referencedTable:
                        $$EquiposTableReferences._clienteIdTable(db),
                    referencedColumn:
                        $$EquiposTableReferences._clienteIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordenesReparacionRefs)
                    await $_getPrefetchedDataByColumns<Equipo, $EquiposTable,
                            OrdenesReparacionData, $OrdenesReparacionTable>(
                        currentTable: table,
                        referencedTable: $$EquiposTableReferences
                            ._ordenesReparacionRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EquiposTableReferences(db, table, p0)
                                .ordenesReparacionRefs,
                        currentColumn: 'id',
                        referencedColumn: 'equipo_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EquiposTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EquiposTable,
    Equipo,
    $$EquiposTableFilterComposer,
    $$EquiposTableOrderingComposer,
    $$EquiposTableAnnotationComposer,
    $$EquiposTableCreateCompanionBuilder,
    $$EquiposTableUpdateCompanionBuilder,
    (Equipo, $$EquiposTableReferences),
    Equipo,
    PrefetchHooks Function({bool clienteId, bool ordenesReparacionRefs})>;
typedef $$RepuestosTableCreateCompanionBuilder = RepuestosCompanion Function({
  Value<int> id,
  required String codigo,
  required String nombre,
  required double precio,
  required int existencias,
});
typedef $$RepuestosTableUpdateCompanionBuilder = RepuestosCompanion Function({
  Value<int> id,
  Value<String> codigo,
  Value<String> nombre,
  Value<double> precio,
  Value<int> existencias,
});

final class $$RepuestosTableReferences
    extends BaseReferences<_$AppDatabase, $RepuestosTable, RepuestosData> {
  $$RepuestosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DetallesOrdenRepuestosTable,
      List<DetallesOrdenRepuesto>> _detallesOrdenRepuestosRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.detallesOrdenRepuestos,
          aliasName: 'repuestos__id__detalles_orden_repuestos__repuesto_id');

  $$DetallesOrdenRepuestosTableProcessedTableManager
      get detallesOrdenRepuestosRefs {
    final manager = $$DetallesOrdenRepuestosTableTableManager(
            $_db, $_db.detallesOrdenRepuestos)
        .filter((f) => f.repuestoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_detallesOrdenRepuestosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RepuestosTableFilterComposer
    extends Composer<_$AppDatabase, $RepuestosTable> {
  $$RepuestosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get existencias => $composableBuilder(
      column: $table.existencias, builder: (column) => ColumnFilters(column));

  Expression<bool> detallesOrdenRepuestosRefs(
      Expression<bool> Function($$DetallesOrdenRepuestosTableFilterComposer f)
          f) {
    final $$DetallesOrdenRepuestosTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.detallesOrdenRepuestos,
            getReferencedColumn: (t) => t.repuestoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DetallesOrdenRepuestosTableFilterComposer(
                  $db: $db,
                  $table: $db.detallesOrdenRepuestos,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$RepuestosTableOrderingComposer
    extends Composer<_$AppDatabase, $RepuestosTable> {
  $$RepuestosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get existencias => $composableBuilder(
      column: $table.existencias, builder: (column) => ColumnOrderings(column));
}

class $$RepuestosTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepuestosTable> {
  $$RepuestosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<int> get existencias => $composableBuilder(
      column: $table.existencias, builder: (column) => column);

  Expression<T> detallesOrdenRepuestosRefs<T extends Object>(
      Expression<T> Function($$DetallesOrdenRepuestosTableAnnotationComposer a)
          f) {
    final $$DetallesOrdenRepuestosTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.detallesOrdenRepuestos,
            getReferencedColumn: (t) => t.repuestoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DetallesOrdenRepuestosTableAnnotationComposer(
                  $db: $db,
                  $table: $db.detallesOrdenRepuestos,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$RepuestosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RepuestosTable,
    RepuestosData,
    $$RepuestosTableFilterComposer,
    $$RepuestosTableOrderingComposer,
    $$RepuestosTableAnnotationComposer,
    $$RepuestosTableCreateCompanionBuilder,
    $$RepuestosTableUpdateCompanionBuilder,
    (RepuestosData, $$RepuestosTableReferences),
    RepuestosData,
    PrefetchHooks Function({bool detallesOrdenRepuestosRefs})> {
  $$RepuestosTableTableManager(_$AppDatabase db, $RepuestosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepuestosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepuestosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepuestosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> codigo = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<double> precio = const Value.absent(),
            Value<int> existencias = const Value.absent(),
          }) =>
              RepuestosCompanion(
            id: id,
            codigo: codigo,
            nombre: nombre,
            precio: precio,
            existencias: existencias,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String codigo,
            required String nombre,
            required double precio,
            required int existencias,
          }) =>
              RepuestosCompanion.insert(
            id: id,
            codigo: codigo,
            nombre: nombre,
            precio: precio,
            existencias: existencias,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RepuestosTable, RepuestosData>(table),
                    $$RepuestosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({detallesOrdenRepuestosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (detallesOrdenRepuestosRefs) db.detallesOrdenRepuestos
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (detallesOrdenRepuestosRefs)
                    await $_getPrefetchedDataByColumns<
                            RepuestosData,
                            $RepuestosTable,
                            DetallesOrdenRepuesto,
                            $DetallesOrdenRepuestosTable>(
                        currentTable: table,
                        referencedTable: $$RepuestosTableReferences
                            ._detallesOrdenRepuestosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RepuestosTableReferences(db, table, p0)
                                .detallesOrdenRepuestosRefs,
                        currentColumn: 'id',
                        referencedColumn: 'repuesto_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RepuestosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RepuestosTable,
    RepuestosData,
    $$RepuestosTableFilterComposer,
    $$RepuestosTableOrderingComposer,
    $$RepuestosTableAnnotationComposer,
    $$RepuestosTableCreateCompanionBuilder,
    $$RepuestosTableUpdateCompanionBuilder,
    (RepuestosData, $$RepuestosTableReferences),
    RepuestosData,
    PrefetchHooks Function({bool detallesOrdenRepuestosRefs})>;
typedef $$OrdenesReparacionTableCreateCompanionBuilder
    = OrdenesReparacionCompanion Function({
  Value<int> id,
  required int equipoId,
  required String fallaReportada,
  required String estado,
  Value<int?> tecnicoId,
  required DateTime fechaCreacion,
});
typedef $$OrdenesReparacionTableUpdateCompanionBuilder
    = OrdenesReparacionCompanion Function({
  Value<int> id,
  Value<int> equipoId,
  Value<String> fallaReportada,
  Value<String> estado,
  Value<int?> tecnicoId,
  Value<DateTime> fechaCreacion,
});

final class $$OrdenesReparacionTableReferences extends BaseReferences<
    _$AppDatabase, $OrdenesReparacionTable, OrdenesReparacionData> {
  $$OrdenesReparacionTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EquiposTable _equipoIdTable(_$AppDatabase db) =>
      db.equipos.createAlias('ordenes_reparacion__equipo_id__equipos__id');

  $$EquiposTableProcessedTableManager get equipoId {
    final $_column = $_itemColumn<int>('equipo_id')!;

    final manager = $$EquiposTableTableManager($_db, $_db.equipos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TecnicosTable _tecnicoIdTable(_$AppDatabase db) =>
      db.tecnicos.createAlias('ordenes_reparacion__tecnico_id__tecnicos__id');

  $$TecnicosTableProcessedTableManager? get tecnicoId {
    final $_column = $_itemColumn<int>('tecnico_id');
    if ($_column == null) return null;
    final manager = $$TecnicosTableTableManager($_db, $_db.tecnicos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tecnicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$DetallesOrdenTrabajosTable,
      List<DetallesOrdenTrabajo>> _detallesOrdenTrabajosRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.detallesOrdenTrabajos,
          aliasName:
              'ordenes_reparacion__id__detalles_orden_trabajos__orden_id');

  $$DetallesOrdenTrabajosTableProcessedTableManager
      get detallesOrdenTrabajosRefs {
    final manager = $$DetallesOrdenTrabajosTableTableManager(
            $_db, $_db.detallesOrdenTrabajos)
        .filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_detallesOrdenTrabajosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DetallesOrdenRepuestosTable,
      List<DetallesOrdenRepuesto>> _detallesOrdenRepuestosRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.detallesOrdenRepuestos,
          aliasName:
              'ordenes_reparacion__id__detalles_orden_repuestos__orden_id');

  $$DetallesOrdenRepuestosTableProcessedTableManager
      get detallesOrdenRepuestosRefs {
    final manager = $$DetallesOrdenRepuestosTableTableManager(
            $_db, $_db.detallesOrdenRepuestos)
        .filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_detallesOrdenRepuestosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OrdenesReparacionTableFilterComposer
    extends Composer<_$AppDatabase, $OrdenesReparacionTable> {
  $$OrdenesReparacionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fallaReportada => $composableBuilder(
      column: $table.fallaReportada,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));

  $$EquiposTableFilterComposer get equipoId {
    final $$EquiposTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.equipoId,
        referencedTable: $db.equipos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EquiposTableFilterComposer(
              $db: $db,
              $table: $db.equipos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TecnicosTableFilterComposer get tecnicoId {
    final $$TecnicosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tecnicoId,
        referencedTable: $db.tecnicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TecnicosTableFilterComposer(
              $db: $db,
              $table: $db.tecnicos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> detallesOrdenTrabajosRefs(
      Expression<bool> Function($$DetallesOrdenTrabajosTableFilterComposer f)
          f) {
    final $$DetallesOrdenTrabajosTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.detallesOrdenTrabajos,
            getReferencedColumn: (t) => t.ordenId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DetallesOrdenTrabajosTableFilterComposer(
                  $db: $db,
                  $table: $db.detallesOrdenTrabajos,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> detallesOrdenRepuestosRefs(
      Expression<bool> Function($$DetallesOrdenRepuestosTableFilterComposer f)
          f) {
    final $$DetallesOrdenRepuestosTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.detallesOrdenRepuestos,
            getReferencedColumn: (t) => t.ordenId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DetallesOrdenRepuestosTableFilterComposer(
                  $db: $db,
                  $table: $db.detallesOrdenRepuestos,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$OrdenesReparacionTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdenesReparacionTable> {
  $$OrdenesReparacionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fallaReportada => $composableBuilder(
      column: $table.fallaReportada,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => ColumnOrderings(column));

  $$EquiposTableOrderingComposer get equipoId {
    final $$EquiposTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.equipoId,
        referencedTable: $db.equipos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EquiposTableOrderingComposer(
              $db: $db,
              $table: $db.equipos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TecnicosTableOrderingComposer get tecnicoId {
    final $$TecnicosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tecnicoId,
        referencedTable: $db.tecnicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TecnicosTableOrderingComposer(
              $db: $db,
              $table: $db.tecnicos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrdenesReparacionTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdenesReparacionTable> {
  $$OrdenesReparacionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fallaReportada => $composableBuilder(
      column: $table.fallaReportada, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);

  $$EquiposTableAnnotationComposer get equipoId {
    final $$EquiposTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.equipoId,
        referencedTable: $db.equipos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EquiposTableAnnotationComposer(
              $db: $db,
              $table: $db.equipos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TecnicosTableAnnotationComposer get tecnicoId {
    final $$TecnicosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tecnicoId,
        referencedTable: $db.tecnicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TecnicosTableAnnotationComposer(
              $db: $db,
              $table: $db.tecnicos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> detallesOrdenTrabajosRefs<T extends Object>(
      Expression<T> Function($$DetallesOrdenTrabajosTableAnnotationComposer a)
          f) {
    final $$DetallesOrdenTrabajosTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.detallesOrdenTrabajos,
            getReferencedColumn: (t) => t.ordenId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DetallesOrdenTrabajosTableAnnotationComposer(
                  $db: $db,
                  $table: $db.detallesOrdenTrabajos,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> detallesOrdenRepuestosRefs<T extends Object>(
      Expression<T> Function($$DetallesOrdenRepuestosTableAnnotationComposer a)
          f) {
    final $$DetallesOrdenRepuestosTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.detallesOrdenRepuestos,
            getReferencedColumn: (t) => t.ordenId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DetallesOrdenRepuestosTableAnnotationComposer(
                  $db: $db,
                  $table: $db.detallesOrdenRepuestos,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$OrdenesReparacionTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdenesReparacionTable,
    OrdenesReparacionData,
    $$OrdenesReparacionTableFilterComposer,
    $$OrdenesReparacionTableOrderingComposer,
    $$OrdenesReparacionTableAnnotationComposer,
    $$OrdenesReparacionTableCreateCompanionBuilder,
    $$OrdenesReparacionTableUpdateCompanionBuilder,
    (OrdenesReparacionData, $$OrdenesReparacionTableReferences),
    OrdenesReparacionData,
    PrefetchHooks Function(
        {bool equipoId,
        bool tecnicoId,
        bool detallesOrdenTrabajosRefs,
        bool detallesOrdenRepuestosRefs})> {
  $$OrdenesReparacionTableTableManager(
      _$AppDatabase db, $OrdenesReparacionTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdenesReparacionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdenesReparacionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdenesReparacionTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> equipoId = const Value.absent(),
            Value<String> fallaReportada = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<int?> tecnicoId = const Value.absent(),
            Value<DateTime> fechaCreacion = const Value.absent(),
          }) =>
              OrdenesReparacionCompanion(
            id: id,
            equipoId: equipoId,
            fallaReportada: fallaReportada,
            estado: estado,
            tecnicoId: tecnicoId,
            fechaCreacion: fechaCreacion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int equipoId,
            required String fallaReportada,
            required String estado,
            Value<int?> tecnicoId = const Value.absent(),
            required DateTime fechaCreacion,
          }) =>
              OrdenesReparacionCompanion.insert(
            id: id,
            equipoId: equipoId,
            fallaReportada: fallaReportada,
            estado: estado,
            tecnicoId: tecnicoId,
            fechaCreacion: fechaCreacion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$OrdenesReparacionTable, OrdenesReparacionData>(
                        table),
                    $$OrdenesReparacionTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {equipoId = false,
              tecnicoId = false,
              detallesOrdenTrabajosRefs = false,
              detallesOrdenRepuestosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (detallesOrdenTrabajosRefs) db.detallesOrdenTrabajos,
                if (detallesOrdenRepuestosRefs) db.detallesOrdenRepuestos
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (equipoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.equipoId,
                    referencedTable:
                        $$OrdenesReparacionTableReferences._equipoIdTable(db),
                    referencedColumn: $$OrdenesReparacionTableReferences
                        ._equipoIdTable(db)
                        .id,
                  ) as T;
                }
                if (tecnicoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tecnicoId,
                    referencedTable:
                        $$OrdenesReparacionTableReferences._tecnicoIdTable(db),
                    referencedColumn: $$OrdenesReparacionTableReferences
                        ._tecnicoIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (detallesOrdenTrabajosRefs)
                    await $_getPrefetchedDataByColumns<
                            OrdenesReparacionData,
                            $OrdenesReparacionTable,
                            DetallesOrdenTrabajo,
                            $DetallesOrdenTrabajosTable>(
                        currentTable: table,
                        referencedTable: $$OrdenesReparacionTableReferences
                            ._detallesOrdenTrabajosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdenesReparacionTableReferences(db, table, p0)
                                .detallesOrdenTrabajosRefs,
                        currentColumn: 'id',
                        referencedColumn: 'orden_id',
                        typedResults: items),
                  if (detallesOrdenRepuestosRefs)
                    await $_getPrefetchedDataByColumns<
                            OrdenesReparacionData,
                            $OrdenesReparacionTable,
                            DetallesOrdenRepuesto,
                            $DetallesOrdenRepuestosTable>(
                        currentTable: table,
                        referencedTable: $$OrdenesReparacionTableReferences
                            ._detallesOrdenRepuestosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdenesReparacionTableReferences(db, table, p0)
                                .detallesOrdenRepuestosRefs,
                        currentColumn: 'id',
                        referencedColumn: 'orden_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OrdenesReparacionTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdenesReparacionTable,
    OrdenesReparacionData,
    $$OrdenesReparacionTableFilterComposer,
    $$OrdenesReparacionTableOrderingComposer,
    $$OrdenesReparacionTableAnnotationComposer,
    $$OrdenesReparacionTableCreateCompanionBuilder,
    $$OrdenesReparacionTableUpdateCompanionBuilder,
    (OrdenesReparacionData, $$OrdenesReparacionTableReferences),
    OrdenesReparacionData,
    PrefetchHooks Function(
        {bool equipoId,
        bool tecnicoId,
        bool detallesOrdenTrabajosRefs,
        bool detallesOrdenRepuestosRefs})>;
typedef $$DetallesOrdenTrabajosTableCreateCompanionBuilder
    = DetallesOrdenTrabajosCompanion Function({
  Value<int> id,
  required int ordenId,
  required String descripcion,
  required double costoManoDeObra,
});
typedef $$DetallesOrdenTrabajosTableUpdateCompanionBuilder
    = DetallesOrdenTrabajosCompanion Function({
  Value<int> id,
  Value<int> ordenId,
  Value<String> descripcion,
  Value<double> costoManoDeObra,
});

final class $$DetallesOrdenTrabajosTableReferences extends BaseReferences<
    _$AppDatabase, $DetallesOrdenTrabajosTable, DetallesOrdenTrabajo> {
  $$DetallesOrdenTrabajosTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $OrdenesReparacionTable _ordenIdTable(_$AppDatabase db) => db
      .ordenesReparacion
      .createAlias('detalles_orden_trabajos__orden_id__ordenes_reparacion__id');

  $$OrdenesReparacionTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<int>('orden_id')!;

    final manager =
        $$OrdenesReparacionTableTableManager($_db, $_db.ordenesReparacion)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DetallesOrdenTrabajosTableFilterComposer
    extends Composer<_$AppDatabase, $DetallesOrdenTrabajosTable> {
  $$DetallesOrdenTrabajosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costoManoDeObra => $composableBuilder(
      column: $table.costoManoDeObra,
      builder: (column) => ColumnFilters(column));

  $$OrdenesReparacionTableFilterComposer get ordenId {
    final $$OrdenesReparacionTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ordenId,
        referencedTable: $db.ordenesReparacion,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesReparacionTableFilterComposer(
              $db: $db,
              $table: $db.ordenesReparacion,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DetallesOrdenTrabajosTableOrderingComposer
    extends Composer<_$AppDatabase, $DetallesOrdenTrabajosTable> {
  $$DetallesOrdenTrabajosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costoManoDeObra => $composableBuilder(
      column: $table.costoManoDeObra,
      builder: (column) => ColumnOrderings(column));

  $$OrdenesReparacionTableOrderingComposer get ordenId {
    final $$OrdenesReparacionTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ordenId,
        referencedTable: $db.ordenesReparacion,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesReparacionTableOrderingComposer(
              $db: $db,
              $table: $db.ordenesReparacion,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DetallesOrdenTrabajosTableAnnotationComposer
    extends Composer<_$AppDatabase, $DetallesOrdenTrabajosTable> {
  $$DetallesOrdenTrabajosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<double> get costoManoDeObra => $composableBuilder(
      column: $table.costoManoDeObra, builder: (column) => column);

  $$OrdenesReparacionTableAnnotationComposer get ordenId {
    final $$OrdenesReparacionTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.ordenId,
            referencedTable: $db.ordenesReparacion,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OrdenesReparacionTableAnnotationComposer(
                  $db: $db,
                  $table: $db.ordenesReparacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$DetallesOrdenTrabajosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DetallesOrdenTrabajosTable,
    DetallesOrdenTrabajo,
    $$DetallesOrdenTrabajosTableFilterComposer,
    $$DetallesOrdenTrabajosTableOrderingComposer,
    $$DetallesOrdenTrabajosTableAnnotationComposer,
    $$DetallesOrdenTrabajosTableCreateCompanionBuilder,
    $$DetallesOrdenTrabajosTableUpdateCompanionBuilder,
    (DetallesOrdenTrabajo, $$DetallesOrdenTrabajosTableReferences),
    DetallesOrdenTrabajo,
    PrefetchHooks Function({bool ordenId})> {
  $$DetallesOrdenTrabajosTableTableManager(
      _$AppDatabase db, $DetallesOrdenTrabajosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DetallesOrdenTrabajosTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$DetallesOrdenTrabajosTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DetallesOrdenTrabajosTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> ordenId = const Value.absent(),
            Value<String> descripcion = const Value.absent(),
            Value<double> costoManoDeObra = const Value.absent(),
          }) =>
              DetallesOrdenTrabajosCompanion(
            id: id,
            ordenId: ordenId,
            descripcion: descripcion,
            costoManoDeObra: costoManoDeObra,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int ordenId,
            required String descripcion,
            required double costoManoDeObra,
          }) =>
              DetallesOrdenTrabajosCompanion.insert(
            id: id,
            ordenId: ordenId,
            descripcion: descripcion,
            costoManoDeObra: costoManoDeObra,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DetallesOrdenTrabajosTable,
                        DetallesOrdenTrabajo>(table),
                    $$DetallesOrdenTrabajosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ordenId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (ordenId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ordenId,
                    referencedTable: $$DetallesOrdenTrabajosTableReferences
                        ._ordenIdTable(db),
                    referencedColumn: $$DetallesOrdenTrabajosTableReferences
                        ._ordenIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DetallesOrdenTrabajosTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $DetallesOrdenTrabajosTable,
        DetallesOrdenTrabajo,
        $$DetallesOrdenTrabajosTableFilterComposer,
        $$DetallesOrdenTrabajosTableOrderingComposer,
        $$DetallesOrdenTrabajosTableAnnotationComposer,
        $$DetallesOrdenTrabajosTableCreateCompanionBuilder,
        $$DetallesOrdenTrabajosTableUpdateCompanionBuilder,
        (DetallesOrdenTrabajo, $$DetallesOrdenTrabajosTableReferences),
        DetallesOrdenTrabajo,
        PrefetchHooks Function({bool ordenId})>;
typedef $$DetallesOrdenRepuestosTableCreateCompanionBuilder
    = DetallesOrdenRepuestosCompanion Function({
  Value<int> id,
  required int ordenId,
  required int repuestoId,
  required int cantidad,
  required double precioUnitario,
});
typedef $$DetallesOrdenRepuestosTableUpdateCompanionBuilder
    = DetallesOrdenRepuestosCompanion Function({
  Value<int> id,
  Value<int> ordenId,
  Value<int> repuestoId,
  Value<int> cantidad,
  Value<double> precioUnitario,
});

final class $$DetallesOrdenRepuestosTableReferences extends BaseReferences<
    _$AppDatabase, $DetallesOrdenRepuestosTable, DetallesOrdenRepuesto> {
  $$DetallesOrdenRepuestosTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $OrdenesReparacionTable _ordenIdTable(_$AppDatabase db) =>
      db.ordenesReparacion.createAlias(
          'detalles_orden_repuestos__orden_id__ordenes_reparacion__id');

  $$OrdenesReparacionTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<int>('orden_id')!;

    final manager =
        $$OrdenesReparacionTableTableManager($_db, $_db.ordenesReparacion)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RepuestosTable _repuestoIdTable(_$AppDatabase db) => db.repuestos
      .createAlias('detalles_orden_repuestos__repuesto_id__repuestos__id');

  $$RepuestosTableProcessedTableManager get repuestoId {
    final $_column = $_itemColumn<int>('repuesto_id')!;

    final manager = $$RepuestosTableTableManager($_db, $_db.repuestos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_repuestoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DetallesOrdenRepuestosTableFilterComposer
    extends Composer<_$AppDatabase, $DetallesOrdenRepuestosTable> {
  $$DetallesOrdenRepuestosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precioUnitario => $composableBuilder(
      column: $table.precioUnitario,
      builder: (column) => ColumnFilters(column));

  $$OrdenesReparacionTableFilterComposer get ordenId {
    final $$OrdenesReparacionTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ordenId,
        referencedTable: $db.ordenesReparacion,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesReparacionTableFilterComposer(
              $db: $db,
              $table: $db.ordenesReparacion,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RepuestosTableFilterComposer get repuestoId {
    final $$RepuestosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.repuestoId,
        referencedTable: $db.repuestos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RepuestosTableFilterComposer(
              $db: $db,
              $table: $db.repuestos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DetallesOrdenRepuestosTableOrderingComposer
    extends Composer<_$AppDatabase, $DetallesOrdenRepuestosTable> {
  $$DetallesOrdenRepuestosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
      column: $table.precioUnitario,
      builder: (column) => ColumnOrderings(column));

  $$OrdenesReparacionTableOrderingComposer get ordenId {
    final $$OrdenesReparacionTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ordenId,
        referencedTable: $db.ordenesReparacion,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesReparacionTableOrderingComposer(
              $db: $db,
              $table: $db.ordenesReparacion,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RepuestosTableOrderingComposer get repuestoId {
    final $$RepuestosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.repuestoId,
        referencedTable: $db.repuestos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RepuestosTableOrderingComposer(
              $db: $db,
              $table: $db.repuestos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DetallesOrdenRepuestosTableAnnotationComposer
    extends Composer<_$AppDatabase, $DetallesOrdenRepuestosTable> {
  $$DetallesOrdenRepuestosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
      column: $table.precioUnitario, builder: (column) => column);

  $$OrdenesReparacionTableAnnotationComposer get ordenId {
    final $$OrdenesReparacionTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.ordenId,
            referencedTable: $db.ordenesReparacion,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OrdenesReparacionTableAnnotationComposer(
                  $db: $db,
                  $table: $db.ordenesReparacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$RepuestosTableAnnotationComposer get repuestoId {
    final $$RepuestosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.repuestoId,
        referencedTable: $db.repuestos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RepuestosTableAnnotationComposer(
              $db: $db,
              $table: $db.repuestos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DetallesOrdenRepuestosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DetallesOrdenRepuestosTable,
    DetallesOrdenRepuesto,
    $$DetallesOrdenRepuestosTableFilterComposer,
    $$DetallesOrdenRepuestosTableOrderingComposer,
    $$DetallesOrdenRepuestosTableAnnotationComposer,
    $$DetallesOrdenRepuestosTableCreateCompanionBuilder,
    $$DetallesOrdenRepuestosTableUpdateCompanionBuilder,
    (DetallesOrdenRepuesto, $$DetallesOrdenRepuestosTableReferences),
    DetallesOrdenRepuesto,
    PrefetchHooks Function({bool ordenId, bool repuestoId})> {
  $$DetallesOrdenRepuestosTableTableManager(
      _$AppDatabase db, $DetallesOrdenRepuestosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DetallesOrdenRepuestosTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$DetallesOrdenRepuestosTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DetallesOrdenRepuestosTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> ordenId = const Value.absent(),
            Value<int> repuestoId = const Value.absent(),
            Value<int> cantidad = const Value.absent(),
            Value<double> precioUnitario = const Value.absent(),
          }) =>
              DetallesOrdenRepuestosCompanion(
            id: id,
            ordenId: ordenId,
            repuestoId: repuestoId,
            cantidad: cantidad,
            precioUnitario: precioUnitario,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int ordenId,
            required int repuestoId,
            required int cantidad,
            required double precioUnitario,
          }) =>
              DetallesOrdenRepuestosCompanion.insert(
            id: id,
            ordenId: ordenId,
            repuestoId: repuestoId,
            cantidad: cantidad,
            precioUnitario: precioUnitario,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DetallesOrdenRepuestosTable,
                        DetallesOrdenRepuesto>(table),
                    $$DetallesOrdenRepuestosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ordenId = false, repuestoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (ordenId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ordenId,
                    referencedTable: $$DetallesOrdenRepuestosTableReferences
                        ._ordenIdTable(db),
                    referencedColumn: $$DetallesOrdenRepuestosTableReferences
                        ._ordenIdTable(db)
                        .id,
                  ) as T;
                }
                if (repuestoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.repuestoId,
                    referencedTable: $$DetallesOrdenRepuestosTableReferences
                        ._repuestoIdTable(db),
                    referencedColumn: $$DetallesOrdenRepuestosTableReferences
                        ._repuestoIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DetallesOrdenRepuestosTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $DetallesOrdenRepuestosTable,
        DetallesOrdenRepuesto,
        $$DetallesOrdenRepuestosTableFilterComposer,
        $$DetallesOrdenRepuestosTableOrderingComposer,
        $$DetallesOrdenRepuestosTableAnnotationComposer,
        $$DetallesOrdenRepuestosTableCreateCompanionBuilder,
        $$DetallesOrdenRepuestosTableUpdateCompanionBuilder,
        (DetallesOrdenRepuesto, $$DetallesOrdenRepuestosTableReferences),
        DetallesOrdenRepuesto,
        PrefetchHooks Function({bool ordenId, bool repuestoId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$TecnicosTableTableManager get tecnicos =>
      $$TecnicosTableTableManager(_db, _db.tecnicos);
  $$EquiposTableTableManager get equipos =>
      $$EquiposTableTableManager(_db, _db.equipos);
  $$RepuestosTableTableManager get repuestos =>
      $$RepuestosTableTableManager(_db, _db.repuestos);
  $$OrdenesReparacionTableTableManager get ordenesReparacion =>
      $$OrdenesReparacionTableTableManager(_db, _db.ordenesReparacion);
  $$DetallesOrdenTrabajosTableTableManager get detallesOrdenTrabajos =>
      $$DetallesOrdenTrabajosTableTableManager(_db, _db.detallesOrdenTrabajos);
  $$DetallesOrdenRepuestosTableTableManager get detallesOrdenRepuestos =>
      $$DetallesOrdenRepuestosTableTableManager(
          _db, _db.detallesOrdenRepuestos);
}
