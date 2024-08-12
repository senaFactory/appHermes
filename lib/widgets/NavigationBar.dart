import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

//* Navegación de la aplicación web

class CustomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      onTap: (index) {
        // if (index == 0) {
        //   Navigator.pushNamed(context, "/");
        // } else if (index == 1) {
        //   Navigator.pushNamed(context, "/equiposPage");
        // }
      },
      height: 70,
      color: Color(0xFF00314D),
      buttonBackgroundColor: Color(0xFF007D78),
      items: [
        Icon(
          Icons.computer,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.qr_code,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.people_alt_outlined,
          size: 30,
          color: Colors.white,
        ),
      ],
    );
  }
}
