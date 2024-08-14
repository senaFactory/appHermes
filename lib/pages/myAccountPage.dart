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
          HomeAppBar(),
          Container(
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  "Mi Cuenta",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00314D),
                  ),
                ),
                SizedBox(height: 15),
                CircleAvatar(
                  radius:
                      110, // Radio del círculo (tamaño de la foto de perfil)
                  backgroundImage: AssetImage(
                      'images/aprendiz_sena1.jpeg'), // Imagen del perfil
                ),
                SizedBox(height: 15),
                Text(
                  "Juan Pedro Navaja Laverde",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00314D),
                  ),
                ),
                SizedBox(height: 55),
                Padding(
                  padding: EdgeInsets.only(left: 30.0), // Espacio desde el borde izquierdo del teléfono
                  child: Row(
                    children: [
                      Icon(
                        Icons.person, // Icono información personal
                        color: Color(0xFF00314D),
                      ),
                      SizedBox(width: 10), // Espacio entre el ícono y el texto
                      Text(
                        "Información personal",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00314D),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.dark_mode,
                        color: Color(0xFF00314D),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Modo oscuro",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00314D),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Color(0xFF00314D),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Cerrar sesión",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00314D),
                        ),
                      ),
                    ],
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
