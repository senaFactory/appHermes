import 'package:flutter/material.dart';
import 'package:maqueta/main.dart';
import 'package:maqueta/features/auth/login_page.dart';
import 'package:maqueta/features/profile/profile_page.dart';
import 'package:maqueta/features/carnet/card_service.dart';
import 'package:maqueta/features/auth/user.dart';
import 'package:maqueta/core/provider/token_storage.dart'; // Importa TokenStorage
import 'package:maqueta/core/wigdets/home_app_bar.dart';

class Myaccountpage extends StatefulWidget {
  final String? role;
  const Myaccountpage({super.key, required this.role});

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

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text(
            'Cerrar sesión',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Estás seguro de que deseas cerrar sesión?',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: Text(
                'Confirmar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
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
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: user == null
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : ListView(
              children: [
                const HomeAppBar(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          "Mi Perfil",
                          style: Theme.of(context).textTheme.titleMedium,
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
                      ListTile(
                        leading: Icon(
                          Icons.dark_mode,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          "Modo oscuro",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        trailing: Switch(
                          value: Theme.of(context).brightness ==
                              Brightness.dark, // Detecta el modo actual
                          onChanged: (value) {
                            MyApp.of(context)
                                .toggleTheme(value); // Cambia el tema
                          },
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        title: Text(
                          "Cerrar sesión",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        onTap: _showLogoutConfirmationDialog,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
