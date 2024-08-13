import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';

class Myaccountpage extends StatefulWidget {
  const Myaccountpage({super.key});

  @override
  State<Myaccountpage> createState() => _MyaccountpageState();
}

class _MyaccountpageState extends State<Myaccountpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          HomeAppBar(), // Barra de navegación personalizada (si la tienes)
          Container( // Agrega un poco de espacio alrededor del contenido
            child: Column(
              children: [
                SizedBox(height: 40), // Espacio en la parte superior
                Text(
                  "Mi Cuenta", // Texto para la sección "Mi Cuenta"
                  style: TextStyle(
                    fontSize: 18, // Tamaño de la fuente
                    fontWeight: FontWeight.w600, // Peso de la fuente
                    color: Color(0xFF00314D), // Color del texto
                  ),
                ),
                SizedBox(height: 15), // Espacio entre el texto y el perfil
                CircleAvatar(
                  radius: 90, // Radio del círculo (tamaño de la foto de perfil)
                  backgroundImage: AssetImage('images/persona_sena2.jpg'), // Imagen del perfil
                ),
                SizedBox(height: 15), // Espacio entre la imagen y el nombre
                Text(
                  "Juan Pedro Navaja Laverde", // Aquí pones el nombre del usuario
                  style: TextStyle(
                    fontSize: 15, // Tamaño de la fuente
                    fontWeight: FontWeight.bold, // Peso de la fuente
                    color: Color(0xFF00314D), // Color del texto
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
