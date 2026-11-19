import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/app_tables.dart';

part 'talleres_dao.g.dart';

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

  static const List<String> estadosValidos = [
    'recibida',
    'en_reparacion',
    'lista',
    'entregada',
    'cancelada',
  ];

  Future<List<OrdenesReparacionData>> obtenerOrdenesAbiertas() {
    return (select(ordenesReparacion)
          ..where((t) => t.estado.isNotIn(['entregada', 'cancelada'])))
        .get();
  }

  Future<void> registrarNuevaOrdenCompleta({
    required String nombreCliente,
    required String telefonoCliente,
    required String tipoEquipo,
    required String marca,
    required String modelo,
    required String numeroSerie,
    required String fallaReportada,
  }) async {
    final nombreLimpio = nombreCliente.trim();
    final telefonoLimpio = telefonoCliente.trim();
    final tipoLimpio = tipoEquipo.trim();
    final marcaLimpia = marca.trim();
    final modeloLimpio = modelo.trim();
    final serieLimpia = numeroSerie.trim();
    final fallaLimpia = fallaReportada.trim();

    if (nombreLimpio.isEmpty) {
      throw ArgumentError('El nombre del cliente es obligatorio.');
    }
    if (telefonoLimpio.isEmpty) {
      throw ArgumentError('El teléfono del cliente es obligatorio.');
    }
    if (tipoLimpio.isEmpty) {
      throw ArgumentError('El tipo de equipo es obligatorio.');
    }
    if (marcaLimpia.isEmpty) {
      throw ArgumentError('La marca del equipo es obligatoria.');
    }
    if (modeloLimpio.isEmpty) {
      throw ArgumentError('El modelo del equipo es obligatorio.');
    }
    if (fallaLimpia.isEmpty) {
      throw ArgumentError('La falla reportada es obligatoria.');
    }

    await transaction(() async {
      final todosClientes = await select(clientes).get();
      Cliente? clienteExistente;
      for (final c in todosClientes) {
        if (c.telefono.trim().toLowerCase() == telefonoLimpio.toLowerCase()) {
          clienteExistente = c;
          break;
        }
      }

      final int clienteId;
      if (clienteExistente != null) {
        clienteId = clienteExistente.id;
        await (update(clientes)..where((t) => t.id.equals(clienteId))).write(
          ClientesCompanion(
            nombre: Value(nombreLimpio),
            telefono: Value(telefonoLimpio),
          ),
        );
      } else {
        clienteId = await into(clientes).insert(
          ClientesCompanion.insert(
            nombre: nombreLimpio,
            telefono: telefonoLimpio,
          ),
        );
      }

      final todosEquipos = await select(equipos).get();
      Equipo? equipoExistente;
      if (serieLimpia.isNotEmpty) {
        for (final eq in todosEquipos) {
          if (eq.numeroSerie.trim().toLowerCase() == serieLimpia.toLowerCase()) {
            equipoExistente = eq;
            break;
          }
        }
      }

      final int equipoId;
      if (equipoExistente != null) {
        equipoId = equipoExistente.id;
        await (update(equipos)..where((t) => t.id.equals(equipoId))).write(
          EquiposCompanion(
            clienteId: Value(clienteId),
            tipo: Value(tipoLimpio),
            marca: Value(marcaLimpia),
            modelo: Value(modeloLimpio),
            numeroSerie: Value(serieLimpia),
          ),
        );
      } else {
        equipoId = await into(equipos).insert(
          EquiposCompanion.insert(
            clienteId: clienteId,
            tipo: tipoLimpio,
            marca: marcaLimpia,
            modelo: modeloLimpio,
            numeroSerie: serieLimpia,
          ),
        );
      }

      await into(ordenesReparacion).insert(
        OrdenesReparacionCompanion.insert(
          equipoId: equipoId,
          fallaReportada: fallaLimpia,
          estado: 'recibida',
          fechaCreacion: DateTime.now(),
        ),
      );
    });
  }

  Future<bool> actualizarEstadoYTecnico(int idOrden, String nuevoEstado, String tecnico) async {
    if (!estadosValidos.contains(nuevoEstado)) {
      throw ArgumentError('Estado no válido: $nuevoEstado');
    }
    final tecnicoLimpio = tecnico.trim();
    final filas = await (update(ordenesReparacion)..where((t) => t.id.equals(idOrden))).write(
      OrdenesReparacionCompanion(
        estado: Value(nuevoEstado),
        tecnicoAsignado: Value(tecnicoLimpio.isEmpty ? null : tecnicoLimpio),
      ),
    );
    return filas > 0;
  }

  Future<int> insertarTrabajo(int ordenId, String descripcion, double costo) {
    final descLimpia = descripcion.trim();
    if (descLimpia.isEmpty) {
      throw ArgumentError('La descripción del trabajo no puede estar vacía.');
    }
    if (costo <= 0 || costo.isNaN || costo.isInfinite) {
      throw ArgumentError('El costo de mano de obra debe ser mayor que 0.');
    }
    return into(detallesOrdenTrabajos).insert(
      DetallesOrdenTrabajosCompanion.insert(
        ordenId: ordenId,
        descripcion: descLimpia,
        costoManoDeObra: costo,
      ),
    );
  }

  Future<List<DetallesOrdenTrabajo>> obtenerTrabajosDeOrden(int ordenId) {
    return (select(detallesOrdenTrabajos)
          ..where((t) => t.ordenId.equals(ordenId)))
        .get();
  }

  Future<List<RepuestosData>> obtenerTodosRepuestos() {
    return select(repuestos).get();
  }

  Future<List<RepuestosData>> obtenerRepuestosStockBajo() {
    return (select(repuestos)
          ..where((t) => t.existencias.isSmallerOrEqual(const Constant(3))))
        .get();
  }

  Future<int> insertarRepuesto(String codigo, String nombre, double precio, int existencias) async {
    final codigoLimpio = codigo.trim();
    final nombreLimpio = nombre.trim();
    if (codigoLimpio.isEmpty) {
      throw ArgumentError('El código del repuesto es obligatorio.');
    }
    if (nombreLimpio.isEmpty) {
      throw ArgumentError('El nombre del repuesto es obligatorio.');
    }
    if (precio < 0 || precio.isNaN || precio.isInfinite) {
      throw ArgumentError('El precio no puede ser negativo.');
    }
    if (existencias < 0) {
      throw ArgumentError('Las existencias iniciales no pueden ser negativas.');
    }

    final existentes = await select(repuestos).get();
    for (final r in existentes) {
      if (r.codigo.trim().toLowerCase() == codigoLimpio.toLowerCase()) {
        throw StateError('Ya existe un repuesto con el código "$codigoLimpio".');
      }
    }

    return into(repuestos).insert(
      RepuestosCompanion.insert(
        codigo: codigoLimpio,
        nombre: nombreLimpio,
        precio: precio,
        existencias: existencias,
      ),
    );
  }

  Future<void> agregarRepuestoAOrden({
    required int ordenId,
    required RepuestosData repuesto,
    required int cantidadUsada,
  }) async {
    if (cantidadUsada <= 0) {
      throw ArgumentError('La cantidad usada debe ser mayor a 0.');
    }
    if (repuesto.existencias < cantidadUsada) {
      throw StateError('Stock insuficiente para ${repuesto.nombre}.');
    }

    await transaction(() async {
      await into(detallesOrdenRepuestos).insert(
        DetallesOrdenRepuestosCompanion.insert(
          ordenId: ordenId,
          repuestoId: repuesto.id,
          cantidad: cantidadUsada,
          precioUnitario: repuesto.precio,
        ),
      );

      final nuevasExistencias = repuesto.existencias - cantidadUsada;
      await (update(repuestos)..where((t) => t.id.equals(repuesto.id))).write(
        RepuestosCompanion(
          existencias: Value(nuevasExistencias < 0 ? 0 : nuevasExistencias),
        ),
      );
    });
  }

  Future<List<RepuestoUsadoItem>> obtenerRepuestosDeOrden(int ordenId) async {
    final query = select(detallesOrdenRepuestos).join([
      innerJoin(repuestos, repuestos.id.equalsExp(detallesOrdenRepuestos.repuestoId)),
    ])..where(detallesOrdenRepuestos.ordenId.equals(ordenId));

    final rows = await query.get();
    return rows
        .map((row) => RepuestoUsadoItem(
              detalle: row.readTable(detallesOrdenRepuestos),
              repuesto: row.readTable(repuestos),
            ))
        .toList();
  }

  Future<double> calcularCostoTotalOrden(int ordenId) async {
    final trabajos = await (select(detallesOrdenTrabajos)
          ..where((t) => t.ordenId.equals(ordenId)))
        .get();

    double totalManoDeObra = 0.0;
    for (var t in trabajos) {
      totalManoDeObra += t.costoManoDeObra;
    }

    final repuestosUsados = await (select(detallesOrdenRepuestos)
          ..where((t) => t.ordenId.equals(ordenId)))
        .get();

    double totalRepuestos = 0.0;
    for (var r in repuestosUsados) {
      totalRepuestos += (r.cantidad * r.precioUnitario);
    }

    return totalManoDeObra + totalRepuestos;
  }

  Future<List<OrdenesReparacionData>> obtenerHistorialPorEquipo(int equipoId) {
    return (select(ordenesReparacion)..where((t) => t.equipoId.equals(equipoId))).get();
  }

  Future<List<HistorialOrdenItem>> buscarHistorialPorEquipo(String filtro) async {
    final limpio = filtro.trim().toLowerCase();
    if (limpio.isEmpty) return [];

    final query = select(ordenesReparacion).join([
      innerJoin(equipos, equipos.id.equalsExp(ordenesReparacion.equipoId)),
      innerJoin(clientes, clientes.id.equalsExp(equipos.clienteId)),
    ])..orderBy([OrderingTerm.desc(ordenesReparacion.fechaCreacion)]);

    final rows = await query.get();
    return rows
        .where((row) {
          final eq = row.readTable(equipos);
          return eq.numeroSerie.toLowerCase().contains(limpio) ||
              eq.modelo.toLowerCase().contains(limpio) ||
              eq.marca.toLowerCase().contains(limpio) ||
              eq.tipo.toLowerCase().contains(limpio);
        })
        .map((row) => HistorialOrdenItem(
              orden: row.readTable(ordenesReparacion),
              equipo: row.readTable(equipos),
              cliente: row.readTable(clientes),
            ))
        .toList();
  }

  Future<List<HistorialOrdenItem>> buscarHistorialPorCliente(String filtro) async {
    final limpio = filtro.trim().toLowerCase();
    if (limpio.isEmpty) return [];

    final query = select(ordenesReparacion).join([
      innerJoin(equipos, equipos.id.equalsExp(ordenesReparacion.equipoId)),
      innerJoin(clientes, clientes.id.equalsExp(equipos.clienteId)),
    ])..orderBy([OrderingTerm.desc(ordenesReparacion.fechaCreacion)]);

    final rows = await query.get();
    return rows
        .where((row) {
          final cli = row.readTable(clientes);
          return cli.nombre.toLowerCase().contains(limpio) ||
              cli.telefono.toLowerCase().contains(limpio);
        })
        .map((row) => HistorialOrdenItem(
              orden: row.readTable(ordenesReparacion),
              equipo: row.readTable(equipos),
              cliente: row.readTable(clientes),
            ))
        .toList();
  }

  Future> obtenerCargaTrabajoPorTecnico() async {
    final ordenes = await (select(ordenesReparacion)
          ..where((t) => t.estado.isNotIn(['entregada', 'cancelada'])))
        .get();

    final Map<String, int> carga = {};
    for (var orden in ordenes) {
      final tecnico = (orden.tecnicoAsignado == null || orden.tecnicoAsignado!.trim().isEmpty)
          ? 'Sin asignar'
          : orden.tecnicoAsignado!.trim();
      carga[tecnico] = (carga[tecnico] ?? 0) + 1;
    }
    return carga;
  }
}
