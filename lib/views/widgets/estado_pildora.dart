import 'package:flutter/material.dart';

// Traduce el estado interno (en_reparacion) a texto legible ("En reparacion").
String estadoBonito(String estado) {
  switch (estado) {
    case 'recibida':
      return 'Recibida';
    case 'en_reparacion':
      return 'En reparacion';
    case 'lista':
      return 'Lista';
    case 'entregada':
      return 'Entregada';
    case 'cancelada':
      return 'Cancelada';
    default:
      return estado;
  }
}

// Devuelve el color asociado a cada estado.
Color colorEstado(String estado) {
  switch (estado) {
    case 'recibida':
      return Colors.blue;
    case 'en_reparacion':
      return Colors.orange;
    case 'lista':
      return Colors.green;
    case 'entregada':
      return Colors.grey;
    case 'cancelada':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

// Pildora de estado reutilizable.
class EstadoPildora extends StatelessWidget {
  final String estado;
  const EstadoPildora({Key? key, required this.estado}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = colorEstado(estado);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        estadoBonito(estado),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
