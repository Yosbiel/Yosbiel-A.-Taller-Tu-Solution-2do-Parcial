import 'package:flutter/material.dart';

// Ruta personalizada para que las pantallas se deslicen suavemente desde la derecha.
class RutaDeslizante<T> extends PageRouteBuilder<T> {
  final Widget page;
  RutaDeslizante({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            // Combinamos la animación con una curva para que no sea lineal
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

// Icono para el BottomNavigationBar que hace un pequeño rebote al seleccionarse.
class IconoRebote extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  const IconoRebote({Key? key, required this.icon, required this.isSelected}) : super(key: key);

  @override
  State<IconoRebote> createState() => _IconoReboteState();
}

class _IconoReboteState extends State<IconoRebote> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    // Animación de 1.0 -> 1.3 -> 1.0 para simular el rebote
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 50),
    ]).animate(_controller);
    
    // Si la pestaña inicia seleccionada, animamos de una vez
    if (widget.isSelected) _controller.forward(from: 0);
  }

  @override
  void didUpdateWidget(covariant IconoRebote oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambia a seleccionado, disparamos la animación
    if (widget.isSelected && !oldWidget.isSelected) _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: Icon(widget.icon));
  }
}
