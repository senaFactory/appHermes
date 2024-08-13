import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';
import 'package:maqueta/widgets/NavigationBar.dart';

class Myaccountpage extends StatefulWidget {
  const Myaccountpage({super.key});

  @override
  State<Myaccountpage> createState() => _MyaccountpageState();
}

class _MyaccountpageState extends State<Myaccountpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        children: [
          HomeAppBar(),
          Text(
            "Pagina de Cuenta"
          ),
        ],
      ),
    );
  }
}