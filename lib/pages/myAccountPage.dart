import 'package:flutter/material.dart';
import 'package:maqueta/pages/pagesSecondarys/personInfoPage.dart';
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
                  radius: 110,
                  backgroundImage: AssetImage('images/aprendiz_sena1.jpeg'),
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
                ListTile(
                  leading: Icon(Icons.person, color: Color(0xFF00314D)),
                  title: Text(
                    "Información personal",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF00314D)),
                  ),
                   contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Personinfopage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.dark_mode, color: Color(0xFF00314D)),
                  title: Text(
                    "Modo oscuro",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF00314D)),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  onTap: () {
                    //* Implementar funcionalidad para cambiar el modo oscuro
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Color(0xFF00314D)),
                  title: Text(
                    "Cerrar sesión",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF00314D)),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  onTap: () {
                    //* Implementar funcionalidad para cerrar sesión
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
