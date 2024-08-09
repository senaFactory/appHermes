import 'package:flutter/material.dart';
import 'package:maqueta/pages/Homepage.dart';
import 'package:maqueta/pages/equiposPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        "/": (context) => Homepage(),
        "/equiposPage": (context) => Equipospage()
      },
    );
  }
}

