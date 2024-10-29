import 'package:flutter/material.dart';
import 'package:maqueta/pages/auth/login_page.dart';
import 'package:maqueta/pages/home_screen.dart';
import 'package:maqueta/util/preferences/pref_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenciaUsuario.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = PreferenciaUsuario();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: prefs.ultimaPagina,
      routes: {
        '/': (context) => LoginPage(), // Primera pantalla(login)
        '/home': (context) => HomeScreen(), // Pantalla principal con navegación
      },
    );
  }
}
