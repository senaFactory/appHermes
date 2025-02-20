import 'package:flutter/material.dart';

//* Personalización de texto para la información del carnet

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
    // Obtener el tema actual
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold, // Mantener negrita
            color: theme.primaryColor, // Usar el color principal del tema
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium
                ?.color, // Mantener el color de texto del tema
          ),
        ),
      ],
    );
  }
}
