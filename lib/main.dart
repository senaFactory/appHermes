import 'package:flutter/material.dart';
import 'package:maqueta/pages/carnetPage.dart';
import 'package:maqueta/pages/equipmentsPage.dart';
import 'package:maqueta/pages/homePage.dart';
import 'package:maqueta/pages/myAccountPage.dart';
import 'package:maqueta/widgets/NavigationBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
      
    Equipmentspage(), // Página 1
    Carnetpage(),     // Página 2
    Myaccountpage(),  // Página 3
  ];

  //* Método que se llama cuando se selecciona una pestaña en la barra de navegación
  
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; //* Actualiza el índice de la página actual
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex, //* Muestra la página correspondiente al índice actual
        children: _pages,
      ),
      bottomNavigationBar: CustomNavigationBar(onTabTapped: _onTabTapped),
    );
  }
}
