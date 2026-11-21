import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/app_tables.dart';
import 'excepciones_taller.dart';

part 'talleres_dao.g.dart';

// ─── MODELOS AUXILIARES ───

class HistorialOrdenItem {
  final OrdenesReparacionData orden;
  final Equipo equipo;
  final Cliente cliente;
  final String? tecnicoNombre;

  HistorialOrdenItem({
    required this.orden,
    required this.equipo,
    required this.cliente,
    required this.tecnicoNombre,
  });
}

class RepuestoUsadoItem {
  final DetallesOrdenRepuesto detalle;
  final RepuestosData repuesto;

  RepuestoUsadoItem({
    required this.detalle,
    required this.repuesto,
  });
}

// ─── ACCESO A DATOS (DAO) ───

@DriftAccessor(tables: [
  OrdenesReparacion,
  Repuestos,
  Clientes,
  Equipos,
  Tecnicos,
  DetallesOrdenTrabajos,
  DetallesOrdenRepuestos
])
class TalleresDao extends DatabaseAccessor<AppDatabase> with _$TalleresDaoMixin {
  TalleresDao(AppDatabase db) : super(db);

  static const List<String> estadosValidos = [
    'recibida', 'en_reparacion', 'lista', 'entregada', 'cancelada',
  ];

  static const Map<String, List<String>> _transicionesPermitidas = {
    'recibida': ['en_reparacion', 'cancelada'],
    'en_reparacion': ['lista', 'cancelada'],
    'lista': ['entregada', 'cancelada'],
    'entregada': <String>[],
    'cancelada': <String>[],
  };

  static final RegExp _telefonoRegex = RegExp(r'^\+?\d{7,15}$');

  static String _validarTelefono(String telefono) {
    final limpio = telefono.trim();
    if (limpio.isEmpty) throw ArgumentError('El teléfono del cliente es obligatorio.');
    if (!_telefonoRegex.hasMatch(limpio)) throw ArgumentError('Teléfono inválido.');
    return limpio;
  }

  static String _validarNoVacio(String valor, String campo) {
    final limpio = valor.trim();
    if (limpio.isEmpty) throw ArgumentError('El campo "$campo" es obligatorio.');
    return limpio;
  }

  // ─── MAPEADORES AUXILIARES (Evitan duplicar código en Future y Stream) ───

  Map<String, int> _mapearCargaTrabajo(List<TypedResult> rows) {
    final carga = <String, int>{};
    for (final row in rows) {
      final tecnicoRaw = row.read(db.ordenesReparacion.tecnicoId);
      final tecnico = (tecnicoRaw == null) ? 'Sin asignar' : tecnicoRaw.toString();
      final cantidad = row.read(db.ordenesReparacion.id.count()) ?? 0;
      carga[tecnico] = (carga[tecnico] ?? 0) + cantidad;
    }
    return carga;
  }

  Future<List<HistorialOrdenItem>> _mapearHistorial(List<TypedResult> rows) async {
    final result = <HistorialOrdenItem>[];
    for (final row in rows) {
      final orden = row.readTable(db.ordenesReparacion);
      result.add(HistorialOrdenItem(
        orden: orden,
        equipo: row.readTable(db.equipos),
        cliente: row.readTable(db.clientes),
        tecnicoNombre: await _nombreTecnico(orden.tecnicoId),
      ));
    }
    return result;
  }

  // ─── LECTURA DE ÓRDENES ───

  Future<List<OrdenesReparacionData>> obtenerOrdenesAbiertas() {
    return (select(db.ordenesReparacion)
          ..where((t) => t.estado.isNotIn(['entregada', 'cancelada']))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .get();
  }

  Stream<List<OrdenesReparacionData>> watchOrdenesAbiertas() {
    return (select(db.ordenesReparacion)
          ..where((t) => t.estado.isNotIn(['entregada', 'cancelada']))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .watch();
  }

  // ─── TÉCNICOS ───

  Stream<List<TecnicosData>> watchTecnicos() {
    return (select(db.tecnicos)..orderBy([(t) => OrderingTerm.asc(t.nombre)])).watch();
  }

  Future<String?> _nombreTecnico(int? tecnicoId) async {
    if (tecnicoId == null) return null;
    final t = await (select(db.tecnicos)..where((t) => t.id.equals(tecnicoId))).getSingleOrNull();
    return t?.nombre;
  }

  // ─── REGISTRO DE ORDEN COMPLETA ───

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
    final serieLimpia = numeroSerie.trim();
    final fallaLimpia = _validarNoVacio(fallaReportada, 'falla reportada');

    await transaction(() async {
      final clienteExistente = await (select(db.clientes)
            ..where((c) => c.telefono.equals(telefonoLimpio)))
          .getSingleOrNull();

      final int clienteId;
      if (clienteExistente != null) {
        clienteId = clienteExistente.id;
        if (clienteExistente.nombre != nombreLimpio) {
          await (update(db.clientes)..where((c) => c.id.equals(clienteId))).write(
            ClientesCompanion(nombre: Value(nombreLimpio)),
          );
        }
      } else {
        clienteId = await into(db.clientes).insert(
          ClientesCompanion.insert(nombre: nombreLimpio, telefono: telefonoLimpio),
        );
      }

      int equipoId;
      Equipo? equipoExistente;
      if (serieLimpia.isNotEmpty) {
        equipoExistente = await (select(db.equipos)
              ..where((e) => e.numeroSerie.equals(serieLimpia)))
            .getSingleOrNull();
      }

      if (equipoExistente != null) {
        if (equipoExistente.clienteId != clienteId) {
          final duenoActual = await (select(db.clientes)
                ..where((c) => c.id.equals(equipoExistente!.clienteId)))
              .getSingle();
          throw EquipoYaRegistradoException(
            'El equipo con serie "$serieLimpia" ya está registrado a nombre de '
            '${duenoActual.nombre} (${duenoActual.telefono}).'
          );
        }
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

  // ─── ESTADO Y TÉCNICO ───

  Future<void> reasignarTecnicoUI(int ordenId, int? tecnicoId) async {
    await transaction(() async {
      final actual = await (select(db.ordenesReparacion)..where((o) => o.id.equals(ordenId))).getSingleOrNull();
      if (actual == null) throw StateError('No existe la orden con id $ordenId.');

      if (actual.estado == 'en_reparacion' && actual.tecnicoId != null && actual.tecnicoId != tecnicoId) {
        final otro = await (select(db.tecnicos)..where((t) => t.id.equals(actual.tecnicoId!))).getSingle();
        throw OrdenBloqueadaException('La orden está en reparación y ya la tiene ${otro.nombre}.');
      }
      await (update(db.ordenesReparacion)..where((o) => o.id.equals(ordenId))).write(
        OrdenesReparacionCompanion(tecnicoId: Value(tecnicoId)),
      );
    });
  }

  Future<bool> actualizarEstadoYTecnico(int idOrden, String nuevoEstado, {int? tecnicoId}) async {
    if (!estadosValidos.contains(nuevoEstado)) throw ArgumentError('Estado no válido: $nuevoEstado');

    return await transaction(() async {
      final actual = await (select(db.ordenesReparacion)..where((o) => o.id.equals(idOrden))).getSingleOrNull();
      if (actual == null) throw StateError('No existe la orden con id $idOrden.');

      final permitidos = _transicionesPermitidas[actual.estado] ?? const [];
      if (actual.estado != nuevoEstado && !permitidos.contains(nuevoEstado)) {
        throw StateError('Transición no permitida: "${actual.estado}" -> "$nuevoEstado".');
      }

      final tecnicoFinal = tecnicoId ?? actual.tecnicoId;

      final filas = await (update(db.ordenesReparacion)..where((o) => o.id.equals(idOrden))).write(
        OrdenesReparacionCompanion(estado: Value(nuevoEstado), tecnicoId: Value(tecnicoFinal)),
      );
      return filas > 0;
    });
  }

  Future<void> liberarOrden(int ordenId) async {
    await (update(db.ordenesReparacion)..where((o) => o.id.equals(ordenId))).write(
      const OrdenesReparacionCompanion(tecnicoId: Value(null)),
    );
  }

  // ─── TRABAJOS Y REPUESTOS ───

  Future<int> insertarTrabajo(int ordenId, String descripcion, double costo) {
    final descLimpia = _validarNoVacio(descripcion, 'descripción del trabajo');
    if (costo <= 0 || costo.isNaN || costo.isInfinite) throw ArgumentError('El costo de mano de obra debe ser mayor que 0.');
    
    return into(db.detallesOrdenTrabajos).insert(
      DetallesOrdenTrabajosCompanion.insert(
        ordenId: ordenId, descripcion: descLimpia, costoManoDeObra: costo,
      ),
    );
  }

  Future<List<DetallesOrdenTrabajo>> obtenerTrabajosDeOrden(int ordenId) {
    return (select(db.detallesOrdenTrabajos)..where((t) => t.ordenId.equals(ordenId))).get();
  }

  Future<List<RepuestosData>> obtenerTodosRepuestos() {
    return (select(db.repuestos)..orderBy([(r) => OrderingTerm.asc(r.nombre)])).get();
  }

  Stream<List<RepuestosData>> watchTodosRepuestos() {
    return (select(db.repuestos)..orderBy([(r) => OrderingTerm.asc(r.nombre)])).watch();
  }

  Stream<List<RepuestosData>> watchRepuestosStockBajo() {
    return (select(db.repuestos)
          ..where((t) => t.existencias.isSmallerOrEqual(const Constant(3)))
          ..orderBy([(r) => OrderingTerm.asc(r.existencias)]))
        .watch();
  }

  Future<int> insertarRepuesto(String codigo, String nombre, double precio, int existencias) async {
    final codigoLimpio = _validarNoVacio(codigo, 'código del repuesto');
    final nombreLimpio = _validarNoVacio(nombre, 'nombre del repuesto');
    if (precio < 0 || precio.isNaN || precio.isInfinite) throw ArgumentError('El precio no puede ser negativo.');
    if (existencias < 0) throw ArgumentError('Las existencias iniciales no pueden ser negativas.');

    final existente = await (select(db.repuestos)..where((r) => r.codigo.equals(codigoLimpio))).getSingleOrNull();
    if (existente != null) throw StateError('Ya existe un repuesto con el código "$codigoLimpio".');

    return into(db.repuestos).insert(
      RepuestosCompanion.insert(codigo: codigoLimpio, nombre: nombreLimpio, precio: precio, existencias: existencias),
    );
  }

  Future<void> actualizarRepuesto({required int id, required String codigo, required String nombre, required double precio, required int existencias}) async {
    final codigoLimpio = _validarNoVacio(codigo, 'código del repuesto');
    final nombreLimpio = _validarNoVacio(nombre, 'nombre del repuesto');
    if (precio < 0 || precio.isNaN || precio.isInfinite) throw ArgumentError('El precio no puede ser negativo.');
    if (existencias < 0) throw ArgumentError('Las existencias no pueden ser negativas.');

    final actual = await (select(db.repuestos)..where((r) => r.id.equals(id))).getSingleOrNull();
    if (actual == null) throw StateError('No existe el repuesto con id $id.');
    
    if (actual.codigo != codigoLimpio) {
      final otro = await (select(db.repuestos)..where((r) => r.codigo.equals(codigoLimpio))).getSingleOrNull();
      if (otro != null) throw StateError('Ya existe otro repuesto con el código "$codigoLimpio".');
    }
    await (update(db.repuestos)..where((r) => r.id.equals(id))).write(
      RepuestosCompanion(codigo: Value(codigoLimpio), nombre: Value(nombreLimpio), precio: Value(precio), existencias: Value(existencias)),
    );
  }

  Future<void> eliminarRepuesto(int id) async {
    final usos = await (select(db.detallesOrdenRepuestos)..where((d) => d.repuestoId.equals(id))).get();
    if (usos.isNotEmpty) throw StateError('No se puede eliminar: el repuesto está usado en ${usos.length} línea(s) de orden.');
    
    final filas = await (delete(db.repuestos)..where((r) => r.id.equals(id))).go();
    if (filas == 0) throw StateError('No existe el repuesto con id $id.');
  }

  Future<void> agregarRepuestoAOrden({required int ordenId, required int repuestoId, required int cantidadUsada}) async {
    if (cantidadUsada <= 0) throw ArgumentError('La cantidad usada debe ser mayor a 0.');
    
    await transaction(() async {
      final repuesto = await (select(db.repuestos)..where((r) => r.id.equals(repuestoId))).getSingleOrNull();
      if (repuesto == null) throw StateError('No existe el repuesto con id $repuestoId.');
      if (repuesto.existencias < cantidadUsada) {
        throw StockInsuficienteException('Stock insuficiente para ${repuesto.nombre}. Disponible: ${repuesto.existencias}.');
      }

      await into(db.detallesOrdenRepuestos).insert(
        DetallesOrdenRepuestosCompanion.insert(ordenId: ordenId, repuestoId: repuestoId, cantidad: cantidadUsada, precioUnitario: repuesto.precio),
      );
      await (update(db.repuestos)..where((r) => r.id.equals(repuestoId))).write(
        RepuestosCompanion(existencias: Value(repuesto.existencias - cantidadUsada)),
      );
    });
  }

  Future<List<RepuestoUsadoItem>> obtenerRepuestosDeOrden(int ordenId) async {
    final query = select(db.detallesOrdenRepuestos).join([
      innerJoin(db.repuestos, db.repuestos.id.equalsExp(db.detallesOrdenRepuestos.repuestoId)),
    ])..where(db.detallesOrdenRepuestos.ordenId.equals(ordenId));
    
    final rows = await query.get();
    return rows.map((row) => RepuestoUsadoItem(
      detalle: row.readTable(db.detallesOrdenRepuestos),
      repuesto: row.readTable(db.repuestos),
    )).toList();
  }

  // ─── COSTOS E HISTORIAL ───

  Future<double> calcularCostoTotalOrden(int ordenId) async {
    final manoObraExpr = db.detallesOrdenTrabajos.costoManoDeObra.sum();
    final manoObraQuery = selectOnly(db.detallesOrdenTrabajos)
      ..addColumns([manoObraExpr])
      ..where(db.detallesOrdenTrabajos.ordenId.equals(ordenId));
    final totalManoObra = (await manoObraQuery.getSingle()).read(manoObraExpr) ?? 0.0;

    final totalLineaExpr = (db.detallesOrdenRepuestos.cantidad.cast<double>() * db.detallesOrdenRepuestos.precioUnitario).sum();
    final repuestosQuery = selectOnly(db.detallesOrdenRepuestos)
      ..addColumns([totalLineaExpr])
      ..where(db.detallesOrdenRepuestos.ordenId.equals(ordenId));
    final totalRepuestos = (await repuestosQuery.getSingle()).read(totalLineaExpr) ?? 0.0;

    return totalManoObra + totalRepuestos;
  }

  Stream<List<OrdenesReparacionData>> watchTodasLasOrdenes() {
    return (select(db.ordenesReparacion)..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)])).watch();
  }

  Future<List<HistorialOrdenItem>> obtenerHistorialCompleto() async {
    final query = select(db.ordenesReparacion).join([
      innerJoin(db.equipos, db.equipos.id.equalsExp(db.ordenesReparacion.equipoId)),
      innerJoin(db.clientes, db.clientes.id.equalsExp(db.equipos.clienteId)),
    ])..orderBy([OrderingTerm.desc(db.ordenesReparacion.fechaCreacion)]);
    
    return _mapearHistorial(await query.get());
  }

  Future<List<HistorialOrdenItem>> buscarHistorialPorEquipo(String filtro) async {
    final limpio = filtro.trim().toLowerCase();
    if (limpio.isEmpty) return [];
    final patron = '%$limpio%';
    final query = select(db.ordenesReparacion).join([
      innerJoin(db.equipos, db.equipos.id.equalsExp(db.ordenesReparacion.equipoId)),
      innerJoin(db.clientes, db.clientes.id.equalsExp(db.equipos.clienteId)),
    ])..where(
        db.equipos.numeroSerie.lower().like(patron) |
        db.equipos.modelo.lower().like(patron) |
        db.equipos.marca.lower().like(patron) |
        db.equipos.tipo.lower().like(patron),
      )..orderBy([OrderingTerm.desc(db.ordenesReparacion.fechaCreacion)]);
    
    return _mapearHistorial(await query.get());
  }

  Future<List<HistorialOrdenItem>> buscarHistorialPorCliente(String filtro) async {
    final limpio = filtro.trim().toLowerCase();
    if (limpio.isEmpty) return [];
    final patron = '%$limpio%';
    final query = select(db.ordenesReparacion).join([
      innerJoin(db.equipos, db.equipos.id.equalsExp(db.ordenesReparacion.equipoId)),
      innerJoin(db.clientes, db.clientes.id.equalsExp(db.equipos.clienteId)),
    ])..where(
        db.clientes.nombre.lower().like(patron) |
        db.clientes.telefono.lower().like(patron),
      )..orderBy([OrderingTerm.desc(db.ordenesReparacion.fechaCreacion)]);
    
    return _mapearHistorial(await query.get());
  }

  // ─── CARGA POR TÉCNICO ───

  Future<Map<String, int>> obtenerCargaTrabajoPorTecnico() async {
    final tecnicoCol = db.ordenesReparacion.tecnicoId;
    final countExpr = db.ordenesReparacion.id.count();

    final query = selectOnly(db.ordenesReparacion)
      ..addColumns([tecnicoCol, countExpr])
      ..where(db.ordenesReparacion.estado.isNotIn(['entregada', 'cancelada']))
      ..groupBy([tecnicoCol]);

    return _mapearCargaTrabajo(await query.get());
  }

  Stream<Map<String, int>> watchCargaTrabajoPorTecnico() {
    final tecnicoCol = db.ordenesReparacion.tecnicoId;
    final countExpr = db.ordenesReparacion.id.count();

    final query = selectOnly(db.ordenesReparacion)
      ..addColumns([tecnicoCol, countExpr])
      ..where(db.ordenesReparacion.estado.isNotIn(['entregada', 'cancelada']))
      ..groupBy([tecnicoCol]);

    return query.watch().map(_mapearCargaTrabajo);
  }
}
