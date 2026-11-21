import 'package:flutter/material.dart';
import '../widgets/animaciones.dart';
import '../widgets/botones_appbar.dart';
import 'ordenes_screen.dart';
import 'inventario_screen.dart';
import 'consultas_screen.dart';

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({Key? key}) : super(key: key);

  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  // Índice de la pestaña actual seleccionada (0: Órdenes, 1: Inventario, 2: Consultas)
  int _indiceActual = 0;

  static const _titulos = ['Órdenes', 'Inventario', 'Consultas'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Animación simple para que el título cambie suavemente al navegar
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
          child: Text(
            _titulos[_indiceActual],
            key: ValueKey<int>(_indiceActual),
          ),
        ),
        actions: const [BotonTema(), BotonInfo()],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Efecto de deslizamiento al cambiar de pestaña
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        // KeyedSubtree asegura que AnimatedSwitcher detecte el cambio de pantalla
        child: KeyedSubtree(
          key: ValueKey<int>(_indiceActual),
          child: [
            const OrdenesScreen(),
            const InventarioScreen(),
            const ConsultasScreen(),
          ][_indiceActual],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (i) => setState(() => _indiceActual = i),
        items: [
          BottomNavigationBarItem(
            icon: IconoRebote(icon: Icons.list_alt, isSelected: _indiceActual == 0),
            label: 'Órdenes',
          ),
          BottomNavigationBarItem(
            icon: IconoRebote(icon: Icons.inventory, isSelected: _indiceActual == 1),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: IconoRebote(icon: Icons.analytics, isSelected: _indiceActual == 2),
            label: 'Consultas',
          ),
        ],
      ),
    );
  }
}
