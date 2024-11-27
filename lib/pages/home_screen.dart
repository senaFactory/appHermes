import 'package:flutter/material.dart';
import 'package:maqueta/pages/carnet/carnet_page.dart';
import 'package:maqueta/pages/equipment/equipments_page.dart';
import 'package:maqueta/pages/profile/my_account_page.dart';
import 'package:maqueta/widgets/navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  final String role; // Agregar el argumento del rol

  const HomeScreen({super.key, required this.role}); // Constructor con rol

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1; // Índice para manejar la pestaña activa

  late final List<Widget>
      _pages; // Inicializar en initState para incluir el rol

  @override
  void initState() {
    super.initState();

    // Inicializar las páginas y pasar el rol a las que lo necesitan
    _pages = [
      Equipmentspage(role: widget.role), // EquipmentsPage acepta rol
      Carnetpage(role: widget.role), // CarnetPage acepta rol
      Myaccountpage(role: widget.role), // MyAccountPage acepta rol
    ];
  }

  // Método que se llama cuando se selecciona una pestaña en la barra de navegación
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Cambia el índice actual
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack para mantener el estado de las páginas cuando se cambia de pestaña
      body: IndexedStack(
        index: _currentIndex,
        children: _pages, // Muestra la página correspondiente al índice actual
      ),
      bottomNavigationBar: CustomNavigationBar(
        onTabTapped: _onTabTapped,
        selectedIndex: _currentIndex,
      ),
    );
  }
}
