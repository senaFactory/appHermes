import 'package:flutter/material.dart';
import 'package:maqueta/pages/homePage.dart';
import 'package:maqueta/pages/equipmentPage.dart';

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
        "/": (context) => homePage(),
        "equiposPage": (context) => Equipospage()
      },
    );
  }
}

