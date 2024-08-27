import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';
import 'package:maqueta/widgets/NavigationBar.dart';

class Personinfopage extends StatelessWidget {
  final Function(int) onTabTapped;

  const Personinfopage({super.key, required this.onTabTapped});

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF00314D),
          ),
        ),
        Text(value),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              const HomeAppBar(),
              const SizedBox(height: 20),
              // Tu contenido aquí
            ],
          ),
          Positioned(
            top: 55,
            left: 5,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(onTabTapped: onTabTapped),
    );
  }
}
