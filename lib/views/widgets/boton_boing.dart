import 'package:flutter/material.dart';

// Botón flotante (FAB) que hace un efecto de "rebote" periódicamente
// para llamar la atención del usuario.
class BotonBoing extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final String tooltip;

  const BotonBoing({
    Key? key,
    required this.child,
    required this.onPressed,
    this.tooltip = '',
  }) : super(key: key);

  @override
  State<BotonBoing> createState() => _BotonBoingState();
}

class _BotonBoingState extends State<BotonBoing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    // Animación que crece y vuelve a su tamaño con un efecto elástico
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.bounceOut)), weight: 50),
    ]).animate(_controller);

    // Iniciamos el ciclo después de 2 segundos para que la app cargue bien
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.forward(from: 0);
        _loop();
      }
    });
  }

  // Bucle infinito que repite la animación cada 5 segundos mientras el widget exista
  void _loop() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: FloatingActionButton(
        tooltip: widget.tooltip,
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}
