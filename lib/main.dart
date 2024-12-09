import 'package:flutter/material.dart';
import 'package:maqueta/pages/auth/login_page.dart';
import 'package:maqueta/pages/home_screen.dart';
import 'package:maqueta/util/preferences/pref_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();

    final String lastPage = prefs.lastPage;
    final String? role = prefs.role;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: lastPage.isNotEmpty ? lastPage : '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => HomeScreen(role: role),
      },
    );
  }
}
