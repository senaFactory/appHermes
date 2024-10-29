import 'package:flutter/material.dart';
import 'package:maqueta/pages/auth/login_page.dart';
import 'package:maqueta/pages/home_screen.dart';
import 'package:maqueta/util/preferences/pref_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: prefs.lastPage,
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
