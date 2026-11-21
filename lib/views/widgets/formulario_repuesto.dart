import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../viewmodels/talleres_providers.dart';

// Diálogo reutilizable para crear o editar un repuesto.
// Si se pasa 'repuesto', entra en modo edición; si no, en modo creación.
Future<void> mostrarFormularioRepuesto(BuildContext context, WidgetRef ref, {RepuestosData? repuesto}) async {
  final esEdicion = repuesto != null;
  final formKey = GlobalKey<FormState>();
  final codigoCtrl = TextEditingController(text: repuesto?.codigo ?? '');
  final nombreCtrl = TextEditingController(text: repuesto?.nombre ?? '');
  final precioCtrl = TextEditingController(text: repuesto != null ? repuesto.precio.toString() : '');
  final stockCtrl = TextEditingController(text: repuesto != null ? repuesto.existencias.toString() : '');
  
  // Variable para mostrar errores que vienen del DAO (ej: código duplicado)
  String? errorServidor;

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDlgState) => AlertDialog(
        title: Text(esEdicion ? 'Editar repuesto' : 'Nuevo repuesto'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: codigoCtrl,
                  decoration: InputDecoration(
                    labelText: 'Código',
                    errorText: errorServidor,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
                ),
                TextFormField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
                ),
                TextFormField(
                  controller: precioCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Precio'),
                  validator: (v) {
                    final n = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
                    if (n == null || n < 0) return 'Precio inválido';
                    return null;
                  },
                ),
                TextFormField(
                  controller: stockCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Existencias'),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    if (n == null || n < 0) return 'Stock inválido';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              setDlgState(() => errorServidor = null);
              if (!formKey.currentState!.validate()) return;
              
              final precio = double.parse(precioCtrl.text.trim().replaceAll(',', '.'));
              final stock = int.parse(stockCtrl.text.trim());
              
              try {
                final dao = ref.read(talleresDaoProvider);
                if (esEdicion) {
                  await dao.actualizarRepuesto(
                    id: repuesto.id,
                    codigo: codigoCtrl.text.trim(),
                    nombre: nombreCtrl.text.trim(),
                    precio: precio,
                    existencias: stock,
                  );
                } else {
                  await dao.insertarRepuesto(
                    codigoCtrl.text.trim(),
                    nombreCtrl.text.trim(),
                    precio,
                    stock,
                  );
                }
                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(esEdicion ? 'Repuesto actualizado' : 'Repuesto creado')),
                  );
                }
              } catch (e) {
                final msg = e.toString();
                // Si el DAO detecta que el código ya existe, lo mostramos en el campo
                if (msg.contains('Ya existe')) {
                  setDlgState(() => errorServidor = 'Ya existe un repuesto con ese código');
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
            child: Text(esEdicion ? 'Guardar' : 'Crear'),
          ),
        ],
      ),
    ),
  );
}
