import 'package:flutter/material.dart';

//* Personalizacion de texto información de carnet

class InfoColumnWidget extends StatelessWidget {
  final String label;
  final String value;

  const InfoColumnWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF39A900),
          ),
        ),
        Text(value),
      ],
    );
  }
}
