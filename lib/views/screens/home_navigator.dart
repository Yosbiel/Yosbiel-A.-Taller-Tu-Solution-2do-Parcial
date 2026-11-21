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
  int _indiceActual = 0;

  static const _titulos = ['Ordenes', 'Inventario', 'Consultas'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: IndexedStack(
        index: _indiceActual,
        children: const [
          OrdenesScreen(),
          InventarioScreen(),
          ConsultasScreen(),
        ],
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
