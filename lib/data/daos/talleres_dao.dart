import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/app_tables.dart';

part 'talleres_dao.g.dart';

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
    await transaction(() async {
      final clienteId = await into(clientes).insert(
        ClientesCompanion.insert(
          nombre: nombreCliente,
          telefono: telefonoCliente,
        ),
      );

      final equipoId = await into(equipos).insert(
        EquiposCompanion.insert(
          clienteId: clienteId,
          tipo: tipoEquipo,
          marca: marca,
          modelo: modelo,
          numeroSerie: numeroSerie,
        ),
      );

      await into(ordenesReparacion).insert(
        OrdenesReparacionCompanion.insert(
          equipoId: equipoId,
          fallaReportada: fallaReportada,
          estado: 'recibida',
          fechaCreacion: DateTime.now(),
        ),
      );
    });
  }

  Future<bool> actualizarEstadoYTecnico(int idOrden, String nuevoEstado, String tecnico) async {
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
    return into(detallesOrdenTrabajos).insert(
      DetallesOrdenTrabajosCompanion.insert(
        ordenId: ordenId,
        descripcion: descripcion,
        costoManoDeObra: costo,
      ),
    );
  }

  Future<List<RepuestosData>> obtenerTodosRepuestos() {
    return select(repuestos).get();
  }

  Future<List<RepuestosData>> obtenerRepuestosStockBajo() {
    return (select(repuestos)
          ..where((t) => t.existencias.isSmallerOrEqual(const Constant(3))))
        .get();
  }

  Future<int> insertarRepuesto(String codigo, String nombre, double precio, int existencias) {
    return into(repuestos).insert(
      RepuestosCompanion.insert(
        codigo: codigo,
        nombre: nombre,
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

  Future<Map<String, int>> obtenerCargaTrabajoPorTecnico() async {
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
