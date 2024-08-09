import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF00314D),
        borderRadius: BorderRadius.circular(7.8), // Cambia el valor para ajustar el redondeo
      ),
      padding: EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/logo.png",
            color: Color.fromARGB(255, 237, 237, 240),
            height: 50,
          ),
          SizedBox(width:5), // Agrega espacio entre el logo y el texto
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hermes",
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w300, // Grosor del texto
                  color: Color(0xFFF5F4F4),
                  letterSpacing: 2.0, // Espacio de las letras
                  height: 1.0, // Ajusta la altura de línea para reducir el espacio vertical
                ),
              ),
              Text(
                "Transformando vidas, construyendo futuro.",
                style: TextStyle(
                  fontSize: 7.4,
                  color: Color(0xFFF5F4F4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
