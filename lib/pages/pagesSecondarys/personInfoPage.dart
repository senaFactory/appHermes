import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';

class Personinfopage extends StatelessWidget {
  const Personinfopage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              HomeAppBar(),
              Container(
                child: const Column(
                  children: [
                    SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Información personal",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00314D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 55, // Ajusta la posición vertical si es necesario
            left: 5, // Ajusta la posición horizontal si es necesario
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
