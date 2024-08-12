import 'package:flutter/material.dart';
import 'package:maqueta/pages/equipmentsPage.dart';
import 'package:maqueta/pages/homePage.dart';


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
        "equipmentsPage": (context) => Equipmentspage()
      },
    );
  }
}

