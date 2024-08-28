import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';

class Personinfopage extends StatelessWidget {
  const Personinfopage({super.key});

  // Método privado que construye las columnas de información
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
              HomeAppBar(),
              SizedBox(height: 20), // Espacio entre la AppBar y el contenido
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Información personal",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00314D),
                      ),
                    ),
                    SizedBox(height: 25),
                    const CircleAvatar(
                      radius: 110, // Radio del círculo (tamaño de la foto de perfil)
                      backgroundImage: AssetImage('images/aprendiz_sena1.jpeg'), // Imagen del perfil
                    ),
                    SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5), // Color de fondo gris claro
                        borderRadius: BorderRadius.circular(20), // Bordes bien redondeados
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 3), // Sombra más suave
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Información personal organizada en columnas
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoColumn("Nombre", "Juan David"),
                              _buildInfoColumn("Número de documento", "1032937844"),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoColumn("Apellido", "Rodríguez Rodríguez"),
                              _buildInfoColumn("Número de celular", "3223999006"),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoColumn("Tipo de sangre", "O+"),
                              _buildInfoColumn("Fecha de nacimiento", "28/12/2000"),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoColumn("Tipo de documento", "C.C"),
                              _buildInfoColumn("Correo electrónico", "JuanR@gmail.com"),
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
          Positioned(
            top: 55,
            left: 5,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
