import 'package:flutter/material.dart';

//* HomeAppBar Se encarga de mostrar la barra superior con el logo y texto.

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00314D),
        borderRadius: BorderRadius.circular(5), // Ajusta el redondeo si es necesario
      ),
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/logo.png",
            color: const Color(0xFF84A5A4),
            height: 50,
          ),
          const SizedBox(width: 5), // Espacio entre el logo y el texto
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
                  height: 1.0, // Ajusta la altura de línea
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
