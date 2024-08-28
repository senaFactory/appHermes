import 'package:flutter/material.dart';

class Carnetpage extends StatefulWidget {
  const Carnetpage({super.key});

  @override
  State<Carnetpage> createState() => _CarnetpageState();
}

class _CarnetpageState extends State<Carnetpage> {
  @override
  Widget build(BuildContext context) {
    // Obtiene el tamaño de la pantalla
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 20),  // Añade un poco de espacio
          Center(
            child: Column(
              children: [
                SizedBox(height: 30),
                Text('Hola, Juan Pedro!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
                SizedBox(height: 20),  // Espacio antes de la imagen
                // Ajusta el tamaño de la imagen basado en el tamaño de la pantalla
                Image.asset(
                  'images/QRimage.png',
                  width: screenSize.width * 0.8,  // 80% del ancho de la pantalla
                  height: screenSize.width * 0.8,  // Mantiene la imagen cuadrada
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
