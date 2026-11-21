// Excepciones personalizadas para el taller.
// Nos permiten distinguir entre tipos de errores en la interfaz
// sin depender de comparar textos (que es frágil si cambia un mensaje).

// Se lanza cuando se intenta registrar un equipo con una serie
// que ya pertenece a otro cliente.
class EquipoYaRegistradoException implements Exception {
  final String mensaje;
  EquipoYaRegistradoException(this.mensaje);
  
  @override
  String toString() => mensaje;
}

// Se lanza cuando un técnico intenta tomar una orden
// que ya está en reparación con otro técnico.
class OrdenBloqueadaException implements Exception {
  final String mensaje;
  OrdenBloqueadaException(this.mensaje);
  
  @override
  String toString() => mensaje;
}

// Se lanza cuando no hay suficientes unidades de un repuesto en el almacén.
class StockInsuficienteException implements Exception {
  final String mensaje;
  StockInsuficienteException(this.mensaje);
  
  @override
  String toString() => mensaje;
}
