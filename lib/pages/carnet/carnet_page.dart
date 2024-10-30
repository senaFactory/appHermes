import 'package:flutter/material.dart';
import 'package:maqueta/pages/carnet/qr_modal.dart';
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/widgets/home_app_bar.dart';
import 'package:maqueta/widgets/info_column.dart';
import 'package:maqueta/services/people_service.dart';
import 'package:maqueta/models/user.dart';

class Carnetpage extends StatefulWidget {
  const Carnetpage({super.key});

  @override
  State<Carnetpage> createState() => _CarnetpageState();
}

class _CarnetpageState extends State<Carnetpage> {
  final PeopleService _peopleService = PeopleService();

  Future<User?> _fetchUserData() {
    final jwt = TokenStorage().decodeJwtToken();
    return _peopleService.getUser();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            children: [
              const HomeAppBar(), // HomeAppBar en la parte superior
              const SizedBox(height: 20),
              FutureBuilder<User?>(
                future: _fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return _buildError(snapshot.error.toString());
                  } else if (!snapshot.hasData) {
                    return _buildNoData();
                  }
                  return Center(
                    child: _buildCarnet(screenSize, snapshot.data!),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError(String errorMessage) {
    return Center(
      child: Text(
        'Error al cargar los datos: $errorMessage',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildNoData() {
    return const Center(
      child: Text(
        'No se encontraron datos del usuario.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildCarnet(Size screenSize, User user) {
    return Container(
      width: screenSize.width * 0.9, // Un poco más ancho
      margin: const EdgeInsets.symmetric(vertical: 30), // Espacio alrededor
      padding: const EdgeInsets.all(25), // Espacio interno
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30), // Bordes más suaves
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Sombra sutil
            blurRadius: 12, // Difuminación de sombra
            spreadRadius: 2,
            offset: const Offset(0, 5), // Sombra hacia abajo
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Imagen del usuario
          const CircleAvatar(
            radius: 70, // Imagen más grande
            backgroundImage: AssetImage('images/aprendiz_sena1.jpeg'),
          ),
          const SizedBox(height: 15),

          // Nombre del usuario
          Text(
            '${user.name} ${user.lastName}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF39A900), // Verde institucional
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          const Text(
            'Aprendiz',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF39A900),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Programa del usuario
          Text(
            user.program,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black54, // Texto más visible
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Botón para mostrar QR
          _buildQrButton(user),
          const SizedBox(height: 20),

          // Detalles del usuario
          _buildUserDetails(user),
        ],
      ),
    );
  }

  Widget _buildQrButton(User user) {
    return ElevatedButton.icon(
      onPressed: () {
        _showQrModal(user);
      },
      icon: const Icon(Icons.qr_code, color: Colors.white),
      label: const Text(
        "Mostrar QR",
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007D78), // Verde oscuro
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12), // Botón con bordes redondeados
        ),
      ),
    );
  }

  void _showQrModal(User user) {
    showDialog(
      context: context,
      builder: (context) => QrModal(user: user),
    );
  }

  Widget _buildUserDetails(User user) {
    return Column(
      children: [
        _buildInfoRow("C.C", user.documentNumber, "RH", user.bloodType),
        const SizedBox(height: 15),
        _buildInfoRow(
            "Número Ficha", user.studySheet, "Centro", user.trainingCenter),
        const SizedBox(height: 15),
        _buildInfoRow("Jornada", user.journal, "Programa", user.program),
      ],
    );
  }

  Widget _buildInfoRow(
      String label1, String value1, String label2, String value2) {
    return Row(
      children: [
        Expanded(
          child: InfoColumnWidget(label: label1, value: value1),
        ),
        Expanded(
          child: InfoColumnWidget(label: label2, value: value2),
        ),
      ],
    );
  }
}
