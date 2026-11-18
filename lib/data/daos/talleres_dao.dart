import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/app_tables.dart';

// Indicamos que este archivo es un DAO vinculado a nuestra base de datos
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

  // 1- Obtener todas las órdenes que no estén entregadas ni canceladas (Órdenes abiertas)
  Future<List<OrdenesReparacionData>> obtenerOrdenesAbiertas() {
    return (select(ordenesReparacion)
          ..where((t) => t.estado.isNotIn(['entregada', 'cancelada'])))
        .get();
  }

  // 2- Registrar Cliente, Equipo y Orden de reparación juntos (Transacción segura)
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
      // Insertar cliente y obtener ID
      final clienteId = await into(clientes).insert(
        ClientesCompanion.insert(
          nombre: nombreCliente,
          telefono: telefonoCliente,
        ),
      );

      // Insertar equipo vinculado al cliente
      final equipoId = await into(equipos).insert(
        EquiposCompanion.insert(
          clienteId: clienteId,
          tipo: tipoEquipo,
          marca: marca,
          modelo: modelo,
          numeroSerie: numeroSerie,
        ),
      );

      // Crear la orden en estado inicial "recibida"
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

  // 3- Actualizar el estado de una orden y cambiar el técnico asignado
  Future<bool> actualizarEstadoYTecnico(int idOrden, String nuevoEstado, String tecnico) {
    return (update(ordenesReparacion)..where((t) => t.id.equals(idOrden))).write(
      OrdenesReparacionCompanion(
        estado: Value(nuevoEstado),
        tecnicoAsignado: Value(tecnico),
      ),
    );
  }

  // 4- Registrar un trabajo de mano de obra en una orden específica
  Future<int> insertarTrabajo(int ordenId, String descripcion, double costo) {
    return into(detallesOrdenTrabajos).insert(
      DetallesOrdenTrabajosCompanion.insert(
        ordenId: ordenId,
        descripcion: descripcion,
        costoManoDeObra: costo,
      ),
    );
  }

  // 5- Obtener todos los repuestos registrados en el almacén
  Future<List<RepuestosData>> obtenerTodosRepuestos() {
    return select(repuestos).get();
  }

  // 6- Consultar repuestos con stock bajo (3 o menos existencias)
  Future<List<RepuestosData>> obtenerRepuestosStockBajo() {
    return (select(repuestos)
          ..where((t) => t.existencias.isSmallerOrEqual(const Constant(3))))
        .get();
  }

  // 7- Agregar un repuesto nuevo al inventario
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

  // 8- Usar un repuesto en una orden y descontar stock automáticamente del almacén
  Future<void> agregarRepuestoAOrden({
    required int ordenId,
    required RepuestosData repuesto,
    required int cantidadUsada,
  }) async {
    await transaction(() async {
      // Registrar el uso del repuesto en la orden
      await into(detallesOrdenRepuestos).insert(
        DetallesOrdenRepuestosCompanion.insert(
          ordenId: ordenId,
          repuestoId: repuesto.id,
          cantidad: cantidadUsada,
          precioUnitario: repuesto.precio,
        ),
      );

      // Calcular y actualizar el nuevo stock (evitando números negativos)
      final nuevasExistencias = repuesto.existencias - cantidadUsada;
      await (update(repuestos)..where((t) => t.id.equals(repuesto.id))).write(
        RepuestosCompanion(
          existencias: Value(nuevasExistencias < 0 ? 0 : nuevasExistencias),
        ),
      );
    });
  }

  // 9- Calcular el costo total de una orden (Suma de mano de obra + repuestos utilizados)
  Future<double> calcularCostoTotalOrden(int ordenId) async {
    // Sumar costos de mano de obra
    final trabajos = await (select(detallesOrdenTrabajos)
          ..where((t) => t.ordenId.equals(ordenId)))
        .get();
    
    double totalManoDeObra = 0.0;
    for (var t in trabajos) {
      totalManoDeObra += t.costoManoDeObra;
    }

    // Sumar costos de repuestos (cantidad * precio unitario)
    final repuestosUsados = await (select(detallesOrdenRepuestos)
          ..where((t) => t.ordenId.equals(ordenId)))
        .get();
        
    double totalRepuestos = 0.0;
    for (var r in repuestosUsados) {
      totalRepuestos += (r.cantidad * r.precioUnitario);
    }

    return totalManoDeObra + totalRepuestos;
  }

  // 10- Obtener historial de órdenes asociadas a un equipo específico
  Future<List<OrdenesReparacionData>> obtenerHistorialPorEquipo(int equipoId) {
    return (select(ordenesReparacion)..where((t) => t.equipoId.equals(equipoId))).get();
  }

  // 11- Obtener la carga de trabajo (conteo de órdenes activas) agrupada por técnico
  Future> obtenerCargaTrabajoPorTecnico() async {
    final ordenes = await (select(ordenesReparacion)
          ..where((t) => t.estado.isNotIn(['entregada', 'cancelada'])))
        .get();

    final Map<String, int> carga = {};
    for (var orden in ordenes) {
      final tecnico = orden.tecnicoAsignado ?? 'Sin asignar';
      carga[tecnico] = (carga[tecnico] ?? 0) + 1;
    }
    return carga;
  }
}
