import 'package:flutter/material.dart';
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

  final List<Widget> _pantallas = [
    const OrdenesScreen(),
    const InventarioScreen(),
    const ConsultasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pantallas[_indiceActual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (index) => setState(() => _indiceActual = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Órdenes'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventario'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Consultas'),
        ],
      ),
    );
  }
}
