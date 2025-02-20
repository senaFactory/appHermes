import 'package:flutter/material.dart';
import 'package:maqueta/features/auth/login_page.dart';
import 'package:maqueta/features/home_screen.dart';
import 'package:maqueta/core/util/app_theme.dart';
import 'package:maqueta/core/util/pref_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    final prefs = UserPreferences();
    _themeMode = prefs.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });

    // Guardar la preferencia de tema
    final prefs = UserPreferences();
    prefs.isDarkMode = isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    final String lastPage = prefs.lastPage;
    final String? role = prefs.role;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      initialRoute: lastPage.isNotEmpty ? lastPage : '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => HomeScreen(role: role),
      },
    );
  }
}
