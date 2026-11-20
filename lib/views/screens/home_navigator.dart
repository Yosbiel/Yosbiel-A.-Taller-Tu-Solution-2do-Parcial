import 'package:flutter/material.dart';
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
        title: Text(_titulos[_indiceActual]),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Ordenes'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventario'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Consultas'),
        ],
      ),
    );
  }
}
