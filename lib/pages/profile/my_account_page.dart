import 'package:flutter/material.dart';
import 'package:maqueta/pages/auth/login_page.dart';
import 'package:maqueta/pages/profile/profile_page.dart';
import 'package:maqueta/services/card_service.dart';
import 'package:maqueta/models/user.dart';
import 'package:maqueta/providers/token_storage.dart'; // Importa TokenStorage
import 'package:maqueta/widgets/home_app_bar.dart';

class Myaccountpage extends StatefulWidget {
  const Myaccountpage({super.key});

  @override
  State<Myaccountpage> createState() => _MyaccountpageState();
}

class _MyaccountpageState extends State<Myaccountpage> {
  bool isDarkMode = false;
  final CardService _peopleService = CardService();
  User? user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? fetchedUser = await _peopleService.getUser();
    setState(() {
      user = fetchedUser;
    });
  }

  Future<void> _logout() async {
    await TokenStorage().deleteToken();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Muestra un diálogo de confirmación antes de cerrar sesión
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Cerrar sesión',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            '¿Estás seguro de que deseas cerrar sesión?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cierra el diálogo
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF39A900)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                _logout(); // Llama a la función de cierre de sesión
              },
              child: const Text(
                'Confirmar',
                style: TextStyle(color: Color(0xFF39A900)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              const HomeAppBar(),
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
                    // ListTile(
                    //   leading: const Icon(Icons.dark_mode, color: Color(0xFF000102)),
                    //   title: const Text(
                    //     "Modo oscuro",
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.w500,
                    //       color: Color(0xFF000102),
                    //     ),
                    //   ),
                    //   contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    //   trailing: Switch(
                    //     value: isDarkMode,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         isDarkMode = value;
                    //       });
                    //     },
                    //     inactiveThumbColor: const Color.fromARGB(255, 93, 171, 65),
                    //     inactiveTrackColor: const Color(0xFFB6E5A8),
                    //     activeColor: const Color.fromARGB(167, 0, 49, 77),
                    //     activeTrackColor: const Color.fromARGB(255, 198, 197, 249),
                    //   ),
                    // ),
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
                      onTap:
                          _showLogoutConfirmationDialog, // Llama al diálogo de confirmación
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
