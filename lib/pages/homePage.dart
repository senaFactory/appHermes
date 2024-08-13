import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';
import 'package:maqueta/widgets/NavigationBar.dart';

class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          HomeAppBar(),
          
        ],
      ),
    );
  }
}
