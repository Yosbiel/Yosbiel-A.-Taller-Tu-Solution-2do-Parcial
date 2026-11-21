// Excepciones personalizadas para el taller.
// Permiten a la interfaz distinguir entre tipos de errores sin comparar textos.

class EquipoYaRegistradoException implements Exception {
  final String mensaje;
  EquipoYaRegistradoException(this.mensaje);
  
  @override
  String toString() => mensaje;
}

class OrdenBloqueadaException implements Exception {
  final String mensaje;
  OrdenBloqueadaException(this.mensaje);
  
  @override
  String toString() => mensaje;
}

class StockInsuficienteException implements Exception {
  final String mensaje;
  StockInsuficienteException(this.mensaje);
  
  @override
  String toString() => mensaje;
}
