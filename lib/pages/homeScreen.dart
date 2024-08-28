import 'package:flutter/material.dart';
import 'package:maqueta/pages/carnetPage.dart';
import 'package:maqueta/pages/equipmentsPage.dart';
import 'package:maqueta/pages/myAccountPage.dart';
import 'package:maqueta/widgets/NavigationBar.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1; 

  // Lista de las páginas a mostrar en IndexedStack
  final List<Widget> _pages = [
    Equipmentspage(),
    Carnetpage(),
    Myaccountpage(),
  ];

  // Función que se llama cuando una pestaña es tocada
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;  // Cambia el índice actual
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,  // Muestra la página correspondiente al índice actual
      ),
      bottomNavigationBar: CustomNavigationBar(onTabTapped: _onTabTapped),  
    );
  }
}
