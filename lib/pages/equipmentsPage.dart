import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';
import 'package:maqueta/widgets/NavigationBar.dart';

class Equipmentspage extends StatefulWidget {
  const Equipmentspage({super.key});

  @override
  State<Equipmentspage> createState() => _EquipmentspageState();
}

class _EquipmentspageState extends State<Equipmentspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ListView(
        children: [
          HomeAppBar(),
          Text(
            "Pagina del equipos"
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(),
      
    );
  }
}