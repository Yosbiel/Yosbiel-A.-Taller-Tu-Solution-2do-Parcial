import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/talleres_providers.dart';

class NuevaOrdenScreen extends ConsumerStatefulWidget {
  const NuevaOrdenScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NuevaOrdenScreen> createState() => _NuevaOrdenScreenState();
}

class _NuevaOrdenScreenState extends ConsumerState<NuevaOrdenScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _marcaCtrl = TextEditingController();
  final _modeloCtrl = TextEditingController();
  final _serieCtrl = TextEditingController();
  final _fallaCtrl = TextEditingController();
  String _tipoSeleccionado = 'Celular';
  bool _guardando = false;

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

  // Normaliza el telefono: quita espacios, guiones y parentesis.
  String _normalizarTelefono(String t) {
    return t.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  }

  String? _validarNoVacio(String? v) {
    if (v == null || v.trim().isEmpty) return 'Campo obligatorio';
    return null;
  }

  String? _validarTelefono(String? v) {
    final normalizado = _normalizarTelefono(v ?? '');
    if (normalizado.isEmpty) return 'Campo obligatorio';
    if (!RegExp(r'^\+?\d{7,15}$').hasMatch(normalizado)) {
      return 'Telefono invalido (7-15 digitos, opcional +)';
    }
    return null;
  }

  Future<void> _guardarOrden() async {
    if (_guardando) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      final dao = ref.read(talleresDaoProvider);
      await dao.registrarNuevaOrdenCompleta(
        nombreCliente: _nombreCtrl.text.trim(),
        telefonoCliente: _normalizarTelefono(_telefonoCtrl.text),
        tipoEquipo: _tipoSeleccionado,
        marca: _marcaCtrl.text.trim(),
        modelo: _modeloCtrl.text.trim(),
        numeroSerie: _serieCtrl.text.trim(),
        fallaReportada: _fallaCtrl.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context);
    } on StateError catch (e) {
      if (!mounted) return;
      // Serie ya registrada a otro dueno: mostrar dialogo claro.
      final mensaje = e.message;
      if (mensaje.contains('ya esta registrado a nombre de')) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Equipo ya registrado'),
            content: Text(mensaje),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
      } else {
        _mostrarSnack('Error: $mensaje');
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarSnack('Error: $e');
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _mostrarSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva orden')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Datos del cliente',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre del dueno'),
              validator: _validarNoVacio,
            ),
            TextFormField(
              controller: _telefonoCtrl,
              decoration: const InputDecoration(
                labelText: 'Telefono',
                helperText: 'Ej: +5355123456 o 5512-3456',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d\+\s\-\(\)]')),
              ],
              validator: _validarTelefono,
            ),
            const SizedBox(height: 20),
            const Text('Datos del equipo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            DropdownButtonFormField<String>(
              value: _tipoSeleccionado,
              decoration: const InputDecoration(labelText: 'Tipo de equipo'),
              items: const ['Celular', 'Tablet', 'Laptop']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _tipoSeleccionado = v);
              },
            ),
            TextFormField(
              controller: _marcaCtrl,
              decoration: const InputDecoration(labelText: 'Marca'),
              validator: _validarNoVacio,
            ),
            TextFormField(
              controller: _modeloCtrl,
              decoration: const InputDecoration(labelText: 'Modelo'),
              validator: _validarNoVacio,
            ),
            TextFormField(
              controller: _serieCtrl,
              decoration: const InputDecoration(
                labelText: 'Numero de serie',
                helperText: 'Opcional si el equipo no tiene serie',
              ),
            ),
            TextFormField(
              controller: _fallaCtrl,
              decoration: const InputDecoration(labelText: 'Falla reportada'),
              maxLines: 2,
              validator: _validarNoVacio,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _guardando ? null : _guardarOrden,
              child: Text(_guardando ? 'Guardando...' : 'Registrar orden'),
            ),
          ],
        ),
      ),
    );
  }
}
