import 'package:flutter/material.dart';
import 'package:maqueta/widgets/info_column.dart';
import 'package:maqueta/services/people_service.dart';
import 'package:maqueta/models/user.dart';

class Carnetpage extends StatefulWidget {
  const Carnetpage({super.key});

  @override
  State<Carnetpage> createState() => _CarnetpageState();
}

class _CarnetpageState extends State<Carnetpage> {
  final PeopleService _peopleService = PeopleService(); // Servicio para obtener los datos

  // Función para obtener los datos del usuario
  Future<User?> _fetchUserData() {
    return _peopleService.getUserById(1); // ID de usuario (puedes cambiar dinámicamente)
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo azul en la parte superior
          _buildBackground(screenSize),
          // Contenido principal que depende de si los datos ya han sido cargados
          FutureBuilder<User?>(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Mientras se cargan los datos
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Si ocurre un error al cargar los datos
                return _buildError(snapshot.error.toString());
              } else if (!snapshot.hasData || snapshot.data == null) {
                // Si no hay datos disponibles
                return _buildNoData();
              }

              // Datos cargados correctamente, mostramos el contenido
              return _buildUserCard(screenSize, snapshot.data!);
            },
          ),
        ],
      ),
    );
  }

  // Widget para el fondo azul
  Widget _buildBackground(Size screenSize) {
    return Container(
      height: screenSize.height * 0.4, // El fondo ocupa el 40% de la pantalla
      color: const Color(0xFF00416A), // Color de fondo azul
    );
  }

  // Widget para mostrar el error
  Widget _buildError(String errorMessage) {
    return Center(
      child: Text(
        'Error al cargar los datos: $errorMessage',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  // Widget para cuando no hay datos
  Widget _buildNoData() {
    return const Center(
      child: Text(
        'No se encontraron datos del usuario.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  // Widget para mostrar los datos del usuario en el carnet
  Widget _buildUserCard(Size screenSize, User user) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildUserInfo(screenSize, user), // Información del usuario
              const SizedBox(height: 20),
              _buildQrImage(screenSize), // Imagen QR
              const SizedBox(height: 20),
              _buildUserDetails(screenSize, user), // Detalles del usuario
            ],
          ),
        ),
      ],
    );
  }

  // Widget para mostrar la información del usuario (nombre y aprendiz)
  Widget _buildUserInfo(Size screenSize, User user) {
    return Container(
      width: screenSize.width * 0.8, // Ancho ajustado con márgenes
      alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alineación del texto a la izquierda
        children: [
          Text(
            'Hola, ${user.name}!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const Text(
            'Aprendiz',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar la imagen QR
  Widget _buildQrImage(Size screenSize) {
    return Container(
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
        width: screenSize.width * 0.7,
        height: screenSize.width * 0.7,
        fit: BoxFit.contain,
      ),
    );
  }

  // Widget para mostrar los detalles del usuario
  Widget _buildUserDetails(Size screenSize, User user) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 253, 251, 251).withOpacity(0.2),
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
                  value: user.name,
                ),
              ),
              Expanded(
                child: InfoColumnWidget(
                  label: "Apellido",
                  value: user.lastName,
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
                  value: user.documentNumber,
                ),
              ),
              Expanded(
                child: InfoColumnWidget(
                  label: "RH",
                  value: user.bloodType,
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
                  value: user.fichaNumber,
                ),
              ),
              Expanded(
                child: InfoColumnWidget(
                  label: "Centro",
                  value: user.serviceCenter,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
