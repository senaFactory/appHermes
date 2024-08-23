import 'package:flutter/material.dart';

class InfoColumnWidget extends StatelessWidget {
  final String label;
  final String value;

  const InfoColumnWidget({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
