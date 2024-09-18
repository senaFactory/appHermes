import 'package:flutter/material.dart';
import 'package:maqueta/widgets/info_column.dart';
import 'package:maqueta/data/mock_data.dart'; // Importa los datos simulados

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
      body: Stack(
        children: [
          // Fondo azul
          Container(
            height:
                screenSize.height * 0.4, // 40% de la pantalla tiene fondo azul
            color: const Color(0xFF00416A), // Color de fondo azul
          ),
          // Contenido principal encima del fondo
          ListView(
            children: [
              const SizedBox(height: 20), // Añade un poco de espacio superior
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 30), // Espacio superior
                    // Contenedor para alinear el texto a la izquierda
                    Container(
                      width: screenSize.width *
                          0.8, // Ancho para darle margen lateral
                      alignment: Alignment
                          .centerLeft, // Alinea el texto a la izquierda
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Alineación dentro del Column
                        children: [
                          Text(
                            'Hola, ${mockUser.name}!',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white, // Color del texto blanco
                            ),
                          ),
                          const Text(
                            'Aprendiz',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white, // Color del texto blanco
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20), // Espacio antes de la imagen
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
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'images/QRimage.png',
                        width: screenSize.width *
                            0.7, // 70% del ancho de la pantalla
                        height: screenSize.width *
                            0.7, // Mantiene la imagen cuadrada
                        fit: BoxFit
                            .contain, // Ajusta la imagen dentro del contenedor
                      ),
                    ),
                    const SizedBox(
                        height: 20), // Espacio entre la imagen y la información
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(
                            0xFFF5F5F5), // Fondo claro para la información personal.
                        borderRadius: BorderRadius.circular(
                            20), // Bordes redondeados para el contenedor.
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 253, 251, 251)
                                .withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: InfoColumnWidget(
                                  label: "Nombre",
                                  value: mockUser.name, // Datos del usuario
                                ),
                              ),
                              Expanded(
                                child: InfoColumnWidget(
                                  label: "Apellido",
                                  value: mockUser.lastName, // Datos del usuario
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: InfoColumnWidget(
                                  label: "C.C",
                                  value: mockUser
                                      .documentNumber, // Datos del usuario
                                ),
                              ),
                              Expanded(
                                child: InfoColumnWidget(
                                  label: "RH",
                                  value:
                                      mockUser.bloodType, // Datos del usuario
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: InfoColumnWidget(
                                  label: "Número Ficha",
                                  value: mockUser
                                      .fichaNumber, // Número de ficha del usuario
                                ),
                              ),
                              Expanded(
                                child: InfoColumnWidget(
                                  label: "Centro de Formación",
                                  value: mockUser
                                      .trainingCenter, // Centro de formación
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
        ],
      ),
    );
  }
}
