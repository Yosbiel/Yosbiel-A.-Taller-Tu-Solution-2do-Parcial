import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/talleres_providers.dart';

class NuevaOrdenScreen extends ConsumerStatefulWidget {
  const NuevaOrdenScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NuevaOrdenScreen> createState() => _NuevaOrdenScreenState();
}

class _NuevaOrdenScreenState extends ConsumerState<NuevaOrdenScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para capturar los datos del formulario
  final _nombreCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _marcaCtrl = TextEditingController();
  final _modeloCtrl = TextEditingController();
  final _serieCtrl = TextEditingController();
  final _fallaCtrl = TextEditingController();

  String _tipoSeleccionado = 'Celular'; // Valor por defecto

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _telefonoCtrl.dispose();
    _marcaCtrl.dispose();
    _modeloCtrl.dispose();
    _serieCtrl.dispose();
    _fallaCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardarOrden() async {
    if (_formKey.currentState!.validate()) {
      final dao = ref.read(talleresDaoProvider);

      await dao.registrarNuevaOrdenCompleta(
        nombreCliente: _nombreCtrl.text.trim(),
        telefonoCliente: _telefonoCtrl.text.trim(),
        tipoEquipo: _tipoSeleccionado,
        marca: _marcaCtrl.text.trim(),
        modelo: _modeloCtrl.text.trim(),
        numeroSerie: _serieCtrl.text.trim(),
        fallaReportada: _fallaCtrl.text.trim(),
      );

      // Refrescamos el provider de órdenes abiertas para que la lista se actualice
      ref.invalidate(ordenesAbiertasProvider);

      if (mounted) {
        Navigator.pop(context); // Regresamos a la pantalla principal
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Orden de Reparación')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Datos del Cliente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre del dueño'),
              validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
            ),
            TextFormField(
              controller: _telefonoCtrl,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: 20),
            const Text('Datos del Equipo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            DropdownButtonFormField<String>(
              value: _tipoSeleccionado,
              decoration: const InputDecoration(labelText: 'Tipo de equipo'),
              items: ['Celular', 'Tablet', 'Laptop']
                  .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                  .toList(),
              onChanged: (val) => setState(() => _tipoSeleccionado = val!),
            ),
            TextFormField(
              controller: _marcaCtrl,
              decoration: const InputDecoration(labelText: 'Marca'),
              validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
            ),
            TextFormField(
              controller: _modeloCtrl,
              decoration: const InputDecoration(labelText: 'Modelo'),
              validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
            ),
            TextFormField(
              controller: _serieCtrl,
              decoration: const InputDecoration(labelText: 'Número de serie'),
              validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
            ),
            TextFormField(
              controller: _fallaCtrl,
              decoration: const InputDecoration(labelText: 'Falla reportada'),
              maxLines: 2,
              validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _guardarOrden,
              child: const Text('Registrar Orden'),
            ),
          ],
        ),
      ),
    );
  }
}
