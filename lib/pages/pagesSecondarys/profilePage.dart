import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  // Método que construye cada columna de información personal
  // 'Expanded' se utiliza para asegurar que cada columna use todo el espacio disponible de manera equitativa
  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
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
      ),
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
              SizedBox(height: 40), // Espacio después de la AppBar
              Center(
                child: Column(
                  children: [
                    Text(
                      "Mi Perfil",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00314D),
                      ),
                    ),
                    SizedBox(height: 25),
                    CircleAvatar(
                      radius: 110, // Tamaño del circulo imagen del perfil.
                      backgroundImage: AssetImage('images/aprendiz_sena1.jpeg'),
                    ),
                    SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5), // Fondo claro para la información personal.
                        borderRadius: BorderRadius.circular(20), // Bordes redondeados para el contenedor.
                        boxShadow: [ // Sombra para dar profundidad al contenedor.
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
                          // Row y Expanded para organizar la información en dos columnas.
                          Row(
                            children: [
                              _buildInfoColumn("Nombre", "Juan Pedro"),
                              _buildInfoColumn("Número de documento", "1032937844"),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              _buildInfoColumn("Apellido", "Navaja Laverde"),
                              _buildInfoColumn("Número de celular", "312574485"),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              _buildInfoColumn("Tipo de sangre", "O+"),
                              _buildInfoColumn("Fecha de nacimiento", "28/12/2000"),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              _buildInfoColumn("Tipo de documento", "C.C"),
                              _buildInfoColumn("Correo electrónico", "Juand@gmail.com"),
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

        //* Funcionalidad de la flecha hacia atras

          Positioned(
            top: 55,
            left: 5,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              // Botón para regresar a la pantalla anterior.
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
