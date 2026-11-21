import 'package:flutter/material.dart';
import '../../data/database/app_database.dart';

// Muestra el diálogo para elegir un repuesto del almacén.
// Devuelve el repuesto seleccionado o null si se cancela.
Future<RepuestosData?> mostrarSelectorRepuesto(BuildContext context, List<RepuestosData> repuestos) async {
  return showDialog<RepuestosData>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Seleccionar repuesto'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: repuestos.length,
          itemBuilder: (_, i) {
            final r = repuestos[i];
            return ListTile(
              title: Text(r.nombre),
              subtitle: Text('Stock: ${r.existencias} | \$${r.precio.toStringAsFixed(2)}'),
              enabled: r.existencias > 0,
              onTap: r.existencias > 0 ? () => Navigator.pop(ctx, r) : null,
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
      ],
    ),
  );
}

// Muestra el diálogo para elegir la cantidad de un repuesto.
// Devuelve la cantidad válida o null si se cancela.
Future<int?> mostrarCantidadRepuesto(BuildContext context, RepuestosData repuesto) async {
  final ctrl = TextEditingController(text: '1');
  final formKey = GlobalKey<FormState>();

  return showDialog<int>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(repuesto.nombre),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Cantidad (máx ${repuesto.existencias})',
          ),
          validator: (v) {
            final n = int.tryParse((v ?? '').trim());
            if (n == null || n <= 0) return 'Cantidad inválida';
            if (n > repuesto.existencias) return 'Solo hay ${repuesto.existencias} en stock';
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;
            Navigator.pop(ctx, int.parse(ctrl.text.trim()));
          },
          child: const Text('Agregar'),
        ),
      ],
    ),
  );
}
