import 'package:flutter/material.dart';
import 'package:maqueta/pages/profile/profile_page.dart';
import 'package:maqueta/services/people_service.dart'; // Importa el servicio
import 'package:maqueta/models/user.dart'; // Importa el modelo User
import 'package:maqueta/widgets/home_app_bar.dart';

class Myaccountpage extends StatefulWidget {
  const Myaccountpage({super.key});

  @override
  State<Myaccountpage> createState() => _MyaccountpageState();
}

class _MyaccountpageState extends State<Myaccountpage> {
  final PeopleService _peopleService = PeopleService(); // Instancia del servicio
  User? user; // Almacena los datos del usuario

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Llamar a la función para obtener los datos al iniciar
  }

  // Función para obtener los datos del usuario
  Future<void> _fetchUserData() async {
    User? fetchedUser = await _peopleService.getUserById(2); // Puedes cambiar el ID dinámicamente

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
                const SizedBox(height: 35),
                const Text(
                  "Mi Cuenta",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00314D),
                  ),
                ),
                const SizedBox(height: 15),
                const CircleAvatar(
                  radius: 110,
                  backgroundImage: AssetImage('images/aprendiz_sena1.jpeg'),
                ),
                const SizedBox(height: 20),
                // Muestra los datos traídos de la API o un placeholder si no se han cargado
                Text(
                  user != null
                      ? "${user!.name} ${user!.lastName}" // Mostrar nombre y apellido traídos de la API
                      : "Cargando datos...", // Placeholder mientras se cargan los datos
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF454546),
                  ),
                ),
                const SizedBox(height: 55),
                ListTile(
                  leading: const Icon(Icons.person, color: Color(0xFF00314D)),
                  title: const Text(
                    "Mi Perfil",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF00314D)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode, color: Color(0xFF00314D)),
                  title: const Text(
                    "Modo oscuro",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF00314D)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  onTap: () {
                    // Implementar funcionalidad para cambiar el modo oscuro
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Color(0xFF00314D)),
                  title: const Text(
                    "Cerrar sesión",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF00314D)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  onTap: () {
                    //TODO: Implementar funcionalidad para cerrar sesión
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
