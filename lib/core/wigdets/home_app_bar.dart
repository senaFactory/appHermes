import 'package:flutter/material.dart';

//* HomeAppBar se encarga de mostrar la barra superior con el logo y texto.

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el tema actual
    final theme = Theme.of(context);

    // Obtener el tamaño de la pantalla
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.primaryColor, // Usar el color principal del tema
        borderRadius: BorderRadius.circular(5), // Ajusta el redondeo
      ),
      padding: EdgeInsets.symmetric(
        vertical: screenSize.height * 0.02, // Adaptable vertical
        horizontal: screenSize.width * 0.05, // Adaptable horizontal
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo adaptable al tamaño de la pantalla
          Image.asset(
            "images/logo.png",
            color: theme.colorScheme.secondary, // Contraste del tema
            height: screenSize.height *
                0.07, // Altura proporcional al alto de la pantalla
          ),
          SizedBox(
            width:
                screenSize.width * 0.02, // Espacio adaptable entre logo y texto
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título con estilos del tema
                Text(
                  "Hermes",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize:
                        screenSize.width * 0.08, // Tamaño relativo al ancho
                    fontWeight:
                        FontWeight.w300, // Mantener el peso especificado
                    letterSpacing: 2.0, // Espaciado entre letras
                    height: 1.0, // Ajusta la altura de línea
                    color: theme.colorScheme.secondary, // Contraste del tema
                  ),
                ),
                // Subtítulo con estilos del tema
                Text(
                  "Transformando vidas, construyendo futuro.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize:
                        screenSize.width * 0.02, // Tamaño relativo al ancho
                    color: theme.colorScheme.secondary, // Contraste del tema
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
