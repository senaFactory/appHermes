import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          HomeAppBar(),
          Container(
            child: Column(
              children: [
                SizedBox(height: 70), //Espacio entre el titulo y el texto
                Container(

                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mis Equipos",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold, // Grosor del texto
                        color: Color(0xFF00314D),
                        height: 1.0, // Ajusta la altura de línea para reducir el espacio vertical
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        onTap: (index){},
        height: 70,
        color: Color(0xFF00314D),
        buttonBackgroundColor: Color(0xFF007D78),
        items:[
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
      ),

    );
  }
}
