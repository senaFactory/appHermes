import 'package:flutter/material.dart';
import 'package:maqueta/pages/profile/profile_page.dart';
import 'package:maqueta/services/people_service.dart';
import 'package:maqueta/models/user.dart';
import 'package:maqueta/widgets/home_app_bar.dart';

class Myaccountpage extends StatefulWidget {
  const Myaccountpage({super.key});

  @override
  State<Myaccountpage> createState() => _MyaccountpageState();
}

class _MyaccountpageState extends State<Myaccountpage> {
  bool isDarkMode = false; // Estado del modo oscuro
  final PeopleService _peopleService =
      PeopleService(); // Instancia del servicio
  User? user; // Almacena los datos del usuario

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Llamar a la función para obtener los datos al iniciar
  }

  // Función para obtener los datos del usuario
  Future<void> _fetchUserData() async {
    User? fetchedUser = await _peopleService
        .getUserById(2); // Puedes cambiar el ID dinámicamente

    setState(() {
      user = fetchedUser; // Actualiza el estado con el usuario obtenido
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const HomeAppBar(),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading:
                            const Icon(Icons.person, color: Color(0xFF000102)),
                        title: const Text(
                          "Mi Perfil",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000102),
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.dark_mode,
                            color: Color(0xFF000102)),
                        title: const Text(
                          "Modo oscuro",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000102),
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        trailing: Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            setState(() {
                              isDarkMode = value; 
                            });                
                          },
                        ),
                      ),
                      const Divider(), // Línea divisoria entre ListTile
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Color.fromARGB(255, 255, 51, 0),
                        ),
                        title: const Text(
                          "Cerrar sesión",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 255, 51, 0),
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        onTap: () {
                          // Lógica para cerrar sesión
                        },
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
