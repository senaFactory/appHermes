import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

//* Navegación entre páginas
class CustomNavigationBar extends StatelessWidget {
  final Function(int) onTabTapped;
  final int selectedIndex;

  const CustomNavigationBar({
    super.key,
    required this.onTabTapped,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener el tema actual
    final theme = Theme.of(context);

    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      height: 70,
      color: theme.primaryColor, // Color principal del tema
      buttonBackgroundColor:
          theme.colorScheme.secondary, // Color secundario del tema
      items: [
        Icon(Icons.computer,
            size: 30,
            color: theme.iconTheme.color), // Icono con el color del tema
        Icon(Icons.qr_code,
            size: 30,
            color: theme.iconTheme.color), // Icono con el color del tema
        Icon(Icons.people_alt_outlined,
            size: 30,
            color: theme.iconTheme.color), // Icono con el color del tema
      ],
      index: selectedIndex, // Pasa el índice inicial
      onTap: onTabTapped, // Cambia la pestaña seleccionada
    );
  }
}
