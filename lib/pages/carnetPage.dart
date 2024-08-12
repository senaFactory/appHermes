import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';
import 'package:maqueta/widgets/NavigationBar.dart';

class Carnetpage extends StatefulWidget {
  const Carnetpage({super.key});

  @override
  State<Carnetpage> createState() => _CarnetpageState();
}

class _CarnetpageState extends State<Carnetpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      
      bottomNavigationBar: CustomNavigationBar(),
    
    );
  }
}