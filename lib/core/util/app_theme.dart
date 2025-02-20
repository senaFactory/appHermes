import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF39A900), // Color principal (verde)
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF39A900), // Color principal
      secondary: Color.fromARGB(255, 255, 255, 255),
      surface: Color(0xFFF3F4F6), // Fondo de la app
      tertiary: Colors.black,
      error: Colors.red, // Color de error
    ),
    textTheme: TextTheme(
      titleLarge: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade800,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        color: Colors.grey.shade700,
      ),
      labelLarge: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF39A900), // Verde para botones
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor:
            const Color(0xFF39A900), // Verde para botones secundarios
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    ),
    iconTheme: const IconThemeData(
      color: Colors.grey, // Iconos grises
    ),
  );
  static ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF00314D), // Color principal (azul oscuro)
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00314D), // Color principal
      secondary: Color.fromARGB(255, 255, 255, 255), // Verde como secundario
      surface: Color.fromARGB(255, 255, 255, 255), // Fondo oscuro
      error: Colors.red, // Color de error
    ),
    scaffoldBackgroundColor: Colors.white, // Cambiar fondo a blanco
    textTheme: TextTheme(
      titleLarge: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors
            .black, // Cambiar color de texto a negro para visibilidad en fondo blanco
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade800, // Color más oscuro para mejor contraste
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        color: Colors.grey.shade700, // Color gris más oscuro para el texto
      ),
      bodyLarge: const TextStyle(
        fontSize: 16.0,
        color: Colors.white, // Color gris más oscuro para el texto
      ),
      labelLarge: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.black, // Cambiar a negro para mejorar la legibilidad
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00314D), // Azul oscuro para botones
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(
            255, 255, 255, 255), // Verde para botones secundarios
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFF00314D), // Color princ
        ),
      ),
      filled: true,
      fillColor: const Color.fromARGB(
          255, 121, 121, 121), // Fondo blanco para los inputs
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    ),

    iconTheme: const IconThemeData(
      color:
          Colors.black, // Cambiar iconos a negro para contraste en fondo blanco
    ),
  );
}
