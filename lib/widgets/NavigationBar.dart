import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

//* Navegación entre paginas
class CustomNavigationBar extends StatelessWidget {
  final Function(int) onTabTapped;

  const CustomNavigationBar({required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      height: 70,
      color: const Color(0xFF00314D),
      buttonBackgroundColor: const Color(0xFF007D78),
      items: const [
        Icon(Icons.computer, size: 30, color: Colors.white),
        Icon(Icons.qr_code, size: 30, color: Colors.white),
        Icon(Icons.people_alt_outlined, size: 30, color: Colors.white),
      ],
      onTap: onTabTapped,
    );
  }
}
