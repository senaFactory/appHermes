import 'package:flutter/material.dart';
import 'package:maqueta/widgets/infoColumn.dart';


class Carnetpage extends StatefulWidget {
  const Carnetpage({super.key});

  @override
  State<Carnetpage> createState() => _CarnetpageState();
}

class _CarnetpageState extends State<Carnetpage> {
  @override
  Widget build(BuildContext context) {
    // Obtiene el tamaño de la pantalla
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 20), // Añade un poco de espacio superior
          Center(
            child: Column(
              children: [
                SizedBox(height: 50), // Espacio superior
                Text(
                  'Hola, Juan Pedro!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF00314D),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Aprendiz',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF00314D),
                  ),
                ),
                SizedBox(height: 20), // Espacio antes de la imagen
                // Ajusta el tamaño de la imagen basado en el tamaño de la pantalla
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'images/QRimage.png',
                    width: screenSize.width * 0.7, // 70% del ancho de la pantalla
                    height: screenSize.width * 0.7, // Mantiene la imagen cuadrada
                  ),
                ),
                SizedBox(height: 20), // Espacio entre la imagen y la información
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5), // Fondo claro para la información personal.
                    borderRadius: BorderRadius.circular(20), // Bordes redondeados para el contenedor.
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Expanded(
                            child: InfoColumnWidget(
                              label: "Nombre",
                              value: "Juan Pedro",
                            ),
                          ),
                          Expanded(
                            child: InfoColumnWidget(
                              label: "Apellido",
                              value: "Navaja Laverde",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: const [
                          Expanded(
                            child: InfoColumnWidget(
                              label: "C.C",
                              value: "1032937844",
                            ),
                          ),
                          Expanded(
                            child: InfoColumnWidget(
                              label: "RH",
                              value: "O+",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: const [
                          Expanded(
                            child: InfoColumnWidget(
                              label: "Número Ficha",
                              value: "2620612",
                            ),
                          ),
                          Expanded(
                            child: InfoColumnWidget(
                              label: "Centro de Servicios Financieros",
                              value: "",
                            ),
                          ),
                        ],
                      ),
                    ],
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

