import 'package:flutter/material.dart';

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

// Color de cada estado, respetando el brightness del theme.
Color colorEstado(String estado, Brightness brightness) {
  final esOscuro = brightness == Brightness.dark;
  switch (estado) {
    case 'recibida':
      return esOscuro ? Colors.lightBlue.shade300 : Colors.blue.shade700;
    case 'en_reparacion':
      return esOscuro ? Colors.orange.shade300 : Colors.orange.shade800;
    case 'lista':
      return esOscuro ? Colors.green.shade300 : Colors.green.shade700;
    case 'entregada':
      return esOscuro ? Colors.grey.shade400 : Colors.grey.shade700;
    case 'cancelada':
      return esOscuro ? Colors.red.shade300 : Colors.red.shade700;
    default:
      return Colors.grey;
  }
}

class EstadoPildora extends StatelessWidget {
  final String estado;
  const EstadoPildora({Key? key, required this.estado}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final color = colorEstado(estado, brightness);
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
