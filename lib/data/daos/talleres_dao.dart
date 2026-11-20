import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/app_tables.dart';

part 'talleres_dao.g.dart';

// Item de historial: una orden con su equipo y su cliente.
class HistorialOrdenItem {
  final OrdenesReparacionData orden;
  final Equipo equipo;
  final Cliente cliente;

  HistorialOrdenItem({
    required this.orden,
    required this.equipo,
    required this.cliente,
  });
}

// Item de repuesto usado: el detalle de la orden y el repuesto del almacen.
class RepuestoUsadoItem {
  final DetallesOrdenRepuesto detalle;
  final RepuestosData repuesto;

  RepuestoUsadoItem({
    required this.detalle,
    required this.repuesto,
  });
}

@DriftAccessor(tables: [
  OrdenesReparacion,
  Repuestos,
  Clientes,
  Equipos,
  DetallesOrdenTrabajos,
  DetallesOrdenRepuestos
])
class TalleresDao extends DatabaseAccessor<AppDatabase> with _$TalleresDaoMixin {
  TalleresDao(AppDatabase db) : super(db);

  // Estados validos del flujo de una orden.
  static const List<String> estadosValidos = [
    'recibida',
    'en_reparacion',
    'lista',
    'entregada',
    'cancelada',
  ];

  // Transiciones permitidas desde cada estado.
  // Entregada y cancelada son estados finales: no permiten salida.
  static const Map<String, List<String>> _transicionesPermitidas = {
    'recibida': ['en_reparacion', 'cancelada'],
    'en_reparacion': ['lista', 'cancelada'],
    'lista': ['entregada', 'cancelada'],
    'entregada': <String>[],
    'cancelada': <String>[],
  };

  // Telefono: opcional '+', entre 7 y 15 digitos. Sin espacios ni guiones.
  static final RegExp _telefonoRegex = RegExp(r'^\+?\d{7,15}$');

  // Valida y normaliza el telefono. Lanza ArgumentError si no cumple.
  static String _validarTelefono(String telefono) {
    final limpio = telefono.trim();
    if (limpio.isEmpty) {
      throw ArgumentError('El telefono del cliente es obligatorio.');
    }
    if (!_telefonoRegex.hasMatch(limpio)) {
      throw ArgumentError(
        'Telefono invalido: "$limpio". Debe tener entre 7 y 15 digitos '
        '(puede empezar con +). Ejemplo: +5355123456 o 55123456.',
      );
    }
    return limpio;
  }

  // Valida que un campo de texto no este vacio. Devuelve el valor con trim.
  static String _validarNoVacio(String valor, String campo) {
    final limpio = valor.trim();
    if (limpio.isEmpty) {
      throw ArgumentError('El campo "$campo" es obligatorio.');
    }
    return limpio;
  }

  // Lista de ordenes abiertas (no entregadas ni canceladas), mas recientes primero.
  Future<List<OrdenesReparacionData>> obtenerOrdenesAbiertas() {
    return (select(db.ordenesReparacion)
          ..where((t) => t.estado.isNotIn(['entregada', 'cancelada']))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .get();
  }

  // Version reactiva de obtenerOrdenesAbiertas. Emite cada vez que cambia la tabla.
  // Se usara en StreamProvider (Parte 2).
  Stream<List<OrdenesReparacionData>> watchOrdenesAbiertas() {
    return (select(db.ordenesReparacion)
          ..where((t) => t.estado.isNotIn(['entregada', 'cancelada']))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .watch();
  }

  // Registra una orden completa: cliente, equipo y orden.
  // Reglas:
  // - Cliente se busca por telefono. Si existe, se actualiza el nombre.
  // - Equipo se busca por numero de serie (si viene).
  //   Si la serie existe y el dueno coincide, se actualizan datos del equipo
  //   sin tocar clienteId.
  //   Si la serie existe y el dueno NO coincide, se lanza StateError.
  //   Para reasignar de forma consciente se usa reasignarEquipoACliente.
  // - La orden se crea en estado 'recibida'.
  Future<void> registrarNuevaOrdenCompleta({
    required String nombreCliente,
    required String telefonoCliente,
    required String tipoEquipo,
    required String marca,
    required String modelo,
    required String numeroSerie,
    required String fallaReportada,
  }) async {
    final nombreLimpio = _validarNoVacio(nombreCliente, 'nombre del cliente');
    final telefonoLimpio = _validarTelefono(telefonoCliente);
    final tipoLimpio = _validarNoVacio(tipoEquipo, 'tipo de equipo');
    final marcaLimpia = _validarNoVacio(marca, 'marca');
    final modeloLimpio = _validarNoVacio(modelo, 'modelo');
    final serieLimpia = numeroSerie.trim(); // la serie puede venir vacia
    final fallaLimpia = _validarNoVacio(fallaReportada, 'falla reportada');

    await transaction(() async {
      // 1) Cliente por telefono.
      final clienteExistente = await (select(db.clientes)
            ..where((c) => c.telefono.equals(telefonoLimpio)))
          .getSingleOrNull();

      final int clienteId;
      if (clienteExistente != null) {
        clienteId = clienteExistente.id;
        // Solo actualizamos nombre si cambio.
        if (clienteExistente.nombre != nombreLimpio) {
          await (update(db.clientes)..where((c) => c.id.equals(clienteId))).write(
            ClientesCompanion(nombre: Value(nombreLimpio)),
          );
        }
      } else {
        clienteId = await into(db.clientes).insert(
          ClientesCompanion.insert(
            nombre: nombreLimpio,
            telefono: telefonoLimpio,
          ),
        );
      }

      // 2) Equipo por serie (si viene).
      int equipoId;
      Equipo? equipoExistente;
      if (serieLimpia.isNotEmpty) {
        equipoExistente = await (select(db.equipos)
              ..where((e) => e.numeroSerie.equals(serieLimpia)))
            .getSingleOrNull();
      }

      if (equipoExistente != null) {
        // Bloqueo de reasignacion silenciosa: si la serie existe pero el
        // dueno no coincide, no se permite seguir.
        if (equipoExistente.clienteId != clienteId) {
          final duenoActual = await (select(db.clientes)
                ..where((c) => c.id.equals(equipoExistente!.clienteId)))
              .getSingle();
          throw StateError(
            'El equipo con serie "$serieLimpia" ya esta registrado a nombre de '
            '${duenoActual.nombre} (${duenoActual.telefono}). '
            'Si es el mismo dueno, corrige el telefono. '
            'Si cambio de dueno, usa la opcion "Reasignar equipo".',
          );
        }
        // Mismo dueno: actualizamos datos del equipo, sin tocar clienteId.
        equipoId = equipoExistente.id;
        await (update(db.equipos)..where((e) => e.id.equals(equipoId))).write(
          EquiposCompanion(
            tipo: Value(tipoLimpio),
            marca: Value(marcaLimpia),
            modelo: Value(modeloLimpio),
          ),
        );
      } else {
        equipoId = await into(db.equipos).insert(
          EquiposCompanion.insert(
            clienteId: clienteId,
            tipo: tipoLimpio,
            marca: marcaLimpia,
            modelo: modeloLimpio,
            numeroSerie: serieLimpia,
          ),
        );
      }

      // 3) Orden.
      await into(db.ordenesReparacion).insert(
        OrdenesReparacionCompanion.insert(
          equipoId: equipoId,
          fallaReportada: fallaLimpia,
          estado: 'recibida',
          fechaCreacion: DateTime.now(),
        ),
      );
    });
  }

  // Reasigna explicitamente un equipo a otro cliente.
  // Uso previsto: boton "Reasignar" en la UI (Parte 3).
  Future<void> reasignarEquipoACliente(int equipoId, int nuevoClienteId) async {
    final existeCliente = await (select(db.clientes)
          ..where((c) => c.id.equals(nuevoClienteId)))
        .getSingleOrNull();
    if (existeCliente == null) {
      throw ArgumentError('No existe el cliente con id $nuevoClienteId.');
    }
    final filas = await (update(db.equipos)..where((e) => e.id.equals(equipoId))).write(
      EquiposCompanion(clienteId: Value(nuevoClienteId)),
    );
    if (filas == 0) {
      throw StateError('No existe el equipo con id $equipoId.');
    }
  }

  // Devuelve el equipo con esa serie, o null si no existe.
  Future<Equipo?> obtenerEquipoPorSerie(String numeroSerie) {
    final limpio = numeroSerie.trim();
    if (limpio.isEmpty) return Future.value(null);
    return (select(db.equipos)..where((e) => e.numeroSerie.equals(limpio)))
        .getSingleOrNull();
  }

  // Actualiza estado y tecnico de una orden.
  // - Valida que nuevoEstado sea valido.
  // - Valida la transicion desde el estado actual.
  // - Si tecnico llega vacio, PRESERVA el tecnico actual.
  //   Para borrarlo explicitamente se usa desasignarTecnico.
  Future<bool> actualizarEstadoYTecnico(
    int idOrden,
    String nuevoEstado, {
    String? tecnico,
  }) async {
    if (!estadosValidos.contains(nuevoEstado)) {
      throw ArgumentError('Estado no valido: $nuevoEstado');
    }

    return await transaction(() async {
      final actual = await (select(db.ordenesReparacion)
            ..where((o) => o.id.equals(idOrden)))
          .getSingleOrNull();
      if (actual == null) {
        throw StateError('No existe la orden con id $idOrden.');
      }

      // Validar transicion.
      final permitidos = _transicionesPermitidas[actual.estado] ?? const [];
      if (actual.estado != nuevoEstado && !permitidos.contains(nuevoEstado)) {
        throw StateError(
          'Transicion no permitida: "${actual.estado}" -> "$nuevoEstado". '
          'Permitidos desde "${actual.estado}": '
          '${permitidos.isEmpty ? "ninguno" : permitidos.join(", ")}.',
        );
      }

      // Preservar tecnico si no llega uno nuevo.
      final tecnicoLimpio = (tecnico ?? '').trim();
      final tecnicoFinal = tecnicoLimpio.isNotEmpty
          ? tecnicoLimpio
          : actual.tecnicoAsignado;

      final filas = await (update(db.ordenesReparacion)
            ..where((o) => o.id.equals(idOrden)))
          .write(
        OrdenesReparacionCompanion(
          estado: Value(nuevoEstado),
          tecnicoAsignado: Value(tecnicoFinal),
        ),
      );
      return filas > 0;
    });
  }

  // Borra explicitamente el tecnico asignado a una orden.
  Future<void> desasignarTecnico(int idOrden) async {
    await (update(db.ordenesReparacion)..where((o) => o.id.equals(idOrden))).write(
      const OrdenesReparacionCompanion(tecnicoAsignado: Value(null)),
    );
  }

  // Registra un trabajo de mano de obra en una orden.
  Future<int> insertarTrabajo(int ordenId, String descripcion, double costo) {
    final descLimpia = _validarNoVacio(descripcion, 'descripcion del trabajo');
    if (costo <= 0 || costo.isNaN || costo.isInfinite) {
      throw ArgumentError('El costo de mano de obra debe ser mayor que 0.');
    }
    return into(db.detallesOrdenTrabajos).insert(
      DetallesOrdenTrabajosCompanion.insert(
        ordenId: ordenId,
        descripcion: descLimpia,
        costoManoDeObra: costo,
      ),
    );
  }

  Future<List<DetallesOrdenTrabajo>> obtenerTrabajosDeOrden(int ordenId) {
    return (select(db.detallesOrdenTrabajos)
          ..where((t) => t.ordenId.equals(ordenId)))
        .get();
  }

  // Lista todos los repuestos del almacen, ordenados por nombre.
  Future<List<RepuestosData>> obtenerTodosRepuestos() {
    return (select(db.repuestos)
          ..orderBy([(r) => OrderingTerm.asc(r.nombre)]))
        .get();
  }

  // Version reactiva de obtenerTodosRepuestos.
  Stream<List<RepuestosData>> watchTodosRepuestos() {
    return (select(db.repuestos)
          ..orderBy([(r) => OrderingTerm.asc(r.nombre)]))
        .watch();
  }

  // Repuestos con stock bajo (existencias <= 3).
  Future<List<RepuestosData>> obtenerRepuestosStockBajo() {
    return (select(db.repuestos)
          ..where((t) => t.existencias.isSmallerOrEqual(const Constant(3)))
          ..orderBy([(r) => OrderingTerm.asc(r.existencias)]))
        .get();
  }

  // Version reactiva de obtenerRepuestosStockBajo.
  Stream<List<RepuestosData>> watchRepuestosStockBajo() {
    return (select(db.repuestos)
          ..where((t) => t.existencias.isSmallerOrEqual(const Constant(3)))
          ..orderBy([(r) => OrderingTerm.asc(r.existencias)]))
        .watch();
  }

  // Inserta un repuesto nuevo. Valida codigo unico.
  Future<int> insertarRepuesto(
    String codigo,
    String nombre,
    double precio,
    int existencias,
  ) async {
    final codigoLimpio = _validarNoVacio(codigo, 'codigo del repuesto');
    final nombreLimpio = _validarNoVacio(nombre, 'nombre del repuesto');
    if (precio < 0 || precio.isNaN || precio.isInfinite) {
      throw ArgumentError('El precio no puede ser negativo.');
    }
    if (existencias < 0) {
      throw ArgumentError('Las existencias iniciales no pueden ser negativas.');
    }

    // Chequeo puntual de duplicado, sin cargar toda la tabla.
    final existente = await (select(db.repuestos)
          ..where((r) => r.codigo.equals(codigoLimpio)))
        .getSingleOrNull();
    if (existente != null) {
      throw StateError('Ya existe un repuesto con el codigo "$codigoLimpio".');
    }

    return into(db.repuestos).insert(
      RepuestosCompanion.insert(
        codigo: codigoLimpio,
        nombre: nombreLimpio,
        precio: precio,
        existencias: existencias,
      ),
    );
  }

  // Actualiza un repuesto existente. No permite cambiar el codigo a uno ya usado.
  Future<void> actualizarRepuesto({
    required int id,
    required String codigo,
    required String nombre,
    required double precio,
    required int existencias,
  }) async {
    final codigoLimpio = _validarNoVacio(codigo, 'codigo del repuesto');
    final nombreLimpio = _validarNoVacio(nombre, 'nombre del repuesto');
    if (precio < 0 || precio.isNaN || precio.isInfinite) {
      throw ArgumentError('El precio no puede ser negativo.');
    }
    if (existencias < 0) {
      throw ArgumentError('Las existencias no pueden ser negativas.');
    }

    // Si el codigo cambio, verificar que el nuevo no exista ya.
    final actual = await (select(db.repuestos)
          ..where((r) => r.id.equals(id)))
        .getSingleOrNull();
    if (actual == null) {
      throw StateError('No existe el repuesto con id $id.');
    }
    if (actual.codigo != codigoLimpio) {
      final otro = await (select(db.repuestos)
            ..where((r) => r.codigo.equals(codigoLimpio)))
          .getSingleOrNull();
      if (otro != null) {
        throw StateError('Ya existe otro repuesto con el codigo "$codigoLimpio".');
      }
    }

    await (update(db.repuestos)..where((r) => r.id.equals(id))).write(
      RepuestosCompanion(
        codigo: Value(codigoLimpio),
        nombre: Value(nombreLimpio),
        precio: Value(precio),
        existencias: Value(existencias),
      ),
    );
  }

  // Elimina un repuesto si no esta usado en ninguna orden.
  Future<void> eliminarRepuesto(int id) async {
    // Contar usos en detalles de orden.
    final usos = await (select(db.detallesOrdenRepuestos)
          ..where((d) => d.repuestoId.equals(id)))
        .get();
    if (usos.isNotEmpty) {
      throw StateError(
        'No se puede eliminar: el repuesto esta usado en '
        '${usos.length} linea(s) de orden.',
      );
    }
    final filas = await (delete(db.repuestos)..where((r) => r.id.equals(id))).go();
    if (filas == 0) {
      throw StateError('No existe el repuesto con id $id.');
    }
  }

  // Agrega un repuesto a una orden y descuenta stock en una sola transaccion.
  // Relee el repuesto dentro de la transaccion para evitar condiciones de carrera.
  Future<void> agregarRepuestoAOrden({
    required int ordenId,
    required int repuestoId,
    required int cantidadUsada,
  }) async {
    if (cantidadUsada <= 0) {
      throw ArgumentError('La cantidad usada debe ser mayor a 0.');
    }

    await transaction(() async {
      // Releer el repuesto dentro de la transaccion.
      final repuesto = await (select(db.repuestos)
            ..where((r) => r.id.equals(repuestoId)))
          .getSingleOrNull();
      if (repuesto == null) {
        throw StateError('No existe el repuesto con id $repuestoId.');
      }
      if (repuesto.existencias < cantidadUsada) {
        throw StateError(
          'Stock insuficiente para ${repuesto.nombre}: '
          'disponible ${repuesto.existencias}, solicitado $cantidadUsada.',
        );
      }

      await into(db.detallesOrdenRepuestos).insert(
        DetallesOrdenRepuestosCompanion.insert(
          ordenId: ordenId,
          repuestoId: repuestoId,
          cantidad: cantidadUsada,
          precioUnitario: repuesto.precio,
        ),
      );

      await (update(db.repuestos)..where((r) => r.id.equals(repuestoId))).write(
        RepuestosCompanion(
          existencias: Value(repuesto.existencias - cantidadUsada),
        ),
      );
    });
  }

  Future<List<RepuestoUsadoItem>> obtenerRepuestosDeOrden(int ordenId) async {
    final query = select(db.detallesOrdenRepuestos).join([
      innerJoin(db.repuestos, db.repuestos.id.equalsExp(db.detallesOrdenRepuestos.repuestoId)),
    ])..where(db.detallesOrdenRepuestos.ordenId.equals(ordenId));

    final rows = await query.get();
    return rows
        .map((row) => RepuestoUsadoItem(
              detalle: row.readTable(db.detallesOrdenRepuestos),
              repuesto: row.readTable(db.repuestos),
            ))
        .toList();
  }

  // Calcula el costo total de una orden con sum() en SQL.
  Future<double> calcularCostoTotalOrden(int ordenId) async {
    final manoObraExpr = db.detallesOrdenTrabajos.costoManoDeObra.sum();
    final manoObraQuery = selectOnly(db.detallesOrdenTrabajos)
      ..addColumns([manoObraExpr])
      ..where(db.detallesOrdenTrabajos.ordenId.equals(ordenId));
    final manoObraRow = await manoObraQuery.getSingle();
    final totalManoObra = manoObraRow.read(manoObraExpr) ?? 0.0;

    final cantExpr = db.detallesOrdenRepuestos.cantidad.cast<int>();
    // Multiplicacion cantidad * precioUnitario por linea.
    final lineaExpr = db.detallesOrdenRepuestos.cantidad *
        db.detallesOrdenRepuestos.precioUnitario;
    final totalLineaExpr = lineaExpr.sum();
    final repuestosQuery = selectOnly(db.detallesOrdenRepuestos)
      ..addColumns([totalLineaExpr])
      ..where(db.detallesOrdenRepuestos.ordenId.equals(ordenId));
    final repuestosRow = await repuestosQuery.getSingle();
    final totalRepuestos = repuestosRow.read(totalLineaExpr) ?? 0.0;

    // Silenciar variable no usada; se deja por claridad.
    // ignore: unused_local_variable
    final _ = cantExpr;

    return totalManoObra + totalRepuestos;
  }

  Future<List<OrdenesReparacionData>> obtenerHistorialPorEquipo(int equipoId) {
    return (select(db.ordenesReparacion)
          ..where((t) => t.equipoId.equals(equipoId))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .get();
  }

  // Busca historial por equipo (serie, marca, modelo o tipo). Filtra en SQL.
  Future<List<HistorialOrdenItem>> buscarHistorialPorEquipo(String filtro) async {
    final limpio = filtro.trim().toLowerCase();
    if (limpio.isEmpty) return [];

    final patron = '%$limpio%';
    final query = select(db.ordenesReparacion).join([
      innerJoin(db.equipos, db.equipos.id.equalsExp(db.ordenesReparacion.equipoId)),
      innerJoin(db.clientes, db.clientes.id.equalsExp(db.equipos.clienteId)),
    ])
      ..where(
        db.equipos.numeroSerie.lower().like(patron) |
            db.equipos.modelo.lower().like(patron) |
            db.equipos.marca.lower().like(patron) |
            db.equipos.tipo.lower().like(patron),
      )
      ..orderBy([OrderingTerm.desc(db.ordenesReparacion.fechaCreacion)]);

    final rows = await query.get();
    return rows
        .map((row) => HistorialOrdenItem(
              orden: row.readTable(db.ordenesReparacion),
              equipo: row.readTable(db.equipos),
              cliente: row.readTable(db.clientes),
            ))
        .toList();
  }

  // Busca historial por cliente (nombre o telefono). Filtra en SQL.
  Future<List<HistorialOrdenItem>> buscarHistorialPorCliente(String filtro) async {
    final limpio = filtro.trim().toLowerCase();
    if (limpio.isEmpty) return [];

    final patron = '%$limpio%';
    final query = select(db.ordenesReparacion).join([
      innerJoin(db.equipos, db.equipos.id.equalsExp(db.ordenesReparacion.equipoId)),
      innerJoin(db.clientes, db.clientes.id.equalsExp(db.equipos.clienteId)),
    ])
      ..where(
        db.clientes.nombre.lower().like(patron) |
            db.clientes.telefono.lower().like(patron),
      )
      ..orderBy([OrderingTerm.desc(db.ordenesReparacion.fechaCreacion)]);

    final rows = await query.get();
    return rows
        .map((row) => HistorialOrdenItem(
              orden: row.readTable(db.ordenesReparacion),
              equipo: row.readTable(db.equipos),
              cliente: row.readTable(db.clientes),
            ))
        .toList();
  }

  // Carga de trabajo por tecnico: agrupa en SQL y cuenta ordenes abiertas.
  Future<Map<String, int>> obtenerCargaTrabajoPorTecnico() async {
    final tecnicoCol = db.ordenesReparacion.tecnicoAsignado;
    final countExpr = db.ordenesReparacion.id.count();

    final query = selectOnly(db.ordenesReparacion)
      ..addColumns([tecnicoCol, countExpr])
      ..where(db.ordenesReparacion.estado.isNotIn(['entregada', 'cancelada']))
      ..groupBy([tecnicoCol]);

    final rows = await query.get();
    final carga = <String, int>{};
    for (final row in rows) {
      final tecnicoRaw = row.read(tecnicoCol);
      final tecnico = (tecnicoRaw == null || tecnicoRaw.trim().isEmpty)
          ? 'Sin asignar'
          : tecnicoRaw.trim();
      final cantidad = row.read(countExpr) ?? 0;
      carga[tecnico] = (carga[tecnico] ?? 0) + cantidad;
    }
    return carga;
  }

  // Version reactiva de obtenerCargaTrabajoPorTecnico.
  Stream<Map<String, int>> watchCargaTrabajoPorTecnico() {
    final tecnicoCol = db.ordenesReparacion.tecnicoAsignado;
    final countExpr = db.ordenesReparacion.id.count();

    final query = selectOnly(db.ordenesReparacion)
      ..addColumns([tecnicoCol, countExpr])
      ..where(db.ordenesReparacion.estado.isNotIn(['entregada', 'cancelada']))
      ..groupBy([tecnicoCol]);

    return query.watch().map((rows) {
      final carga = <String, int>{};
      for (final row in rows) {
        final tecnicoRaw = row.read(tecnicoCol);
        final tecnico = (tecnicoRaw == null || tecnicoRaw.trim().isEmpty)
            ? 'Sin asignar'
            : tecnicoRaw.trim();
        final cantidad = row.read(countExpr) ?? 0;
        carga[tecnico] = (carga[tecnico] ?? 0) + cantidad;
      }
      return carga;
    });
  }
}
