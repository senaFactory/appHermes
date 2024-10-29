import 'package:flutter/material.dart';

//* HomeAppBar se encarga de mostrar la barra superior con el logo y texto.

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color =  Color(0xFF39A900);
    // Obtener el tamaño de la pantalla
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5), // Ajusta el redondeo
      ),
      padding: EdgeInsets.symmetric(
        vertical: screenSize.height * 0.02, // Adaptable vertical
        horizontal: screenSize.width * 0.05, // Adaptable horizontal
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo adaptable al tamaño de la pantalla
          Image.asset(
            "images/logo.png",
            color: Color.fromARGB(255, 241, 241, 241),
            height: screenSize.height * 0.07, // Altura proporcional al alto de la pantalla
          ),
          SizedBox(width: screenSize.width * 0.02), // Espacio adaptable entre logo y texto
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título con tamaño proporcional al ancho de la pantalla
                Text(
                  "Hermes",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.08, // Tamaño relativo al ancho
                    fontWeight: FontWeight.w300, 
                    color: const Color(0xFFF5F4F4),
                    letterSpacing: 2.0, // Espacio de las letras
                    height: 1.0, // Ajusta la altura de línea
                  ),
                ),
                
                Text(
                  "Transformando vidas, construyendo futuro.",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.02, // Tamaño proporcional al ancho
                    color: const Color(0xFFF5F4F4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
