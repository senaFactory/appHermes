import 'package:flutter/material.dart';
import 'package:maqueta/widgets/info_column.dart';
import 'package:maqueta/services/people_service.dart';
import 'package:maqueta/models/user.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class Carnetpage extends StatefulWidget {
  const Carnetpage({super.key});

  @override
  State<Carnetpage> createState() => _CarnetpageState();
}

class _CarnetpageState extends State<Carnetpage> {
  final PeopleService _peopleService = PeopleService();

  // Función para obtener los datos del usuario
  Future<User?> _fetchUserData() {
    return _peopleService.getUserById(2);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(screenSize),
          FutureBuilder<User?>(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return _buildError(snapshot.error.toString());
              } else if (!snapshot.hasData || snapshot.data == null) {
                return _buildNoData();
              }

              return _buildUserCard(screenSize, snapshot.data!);
            },
          ),
        ],
      ),
    );
  }

  // Fondo azul en la parte superior
  Widget _buildBackground(Size screenSize) {
    return Container(
      height: screenSize.height * 0.4,
      color: const Color(0xFF39A900),
    );
  }

  // Widget para mostrar error
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

  // Widget para mostrar los datos del usuario y el QR
  Widget _buildUserCard(Size screenSize, User user) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildUserInfo(screenSize, user),
              const SizedBox(height: 20),
              _buildQrCode(screenSize, user), // Nuevo widget QR code
              const SizedBox(height: 20),
              _buildUserDetails(screenSize, user),
            ],
          ),
        ),
      ],
    );
  }

  // Widget para mostrar la información del usuario
  Widget _buildUserInfo(Size screenSize, User user) {
    return Container(
      width: screenSize.width * 0.8,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

  // Nuevo widget QR code mejorado
// Nuevo widget QR code con PrettyQrView.data
  Widget _buildQrCode(Size screenSize, User user) {
    return Container(
      padding: const EdgeInsets.all(50.0),
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
      child: PrettyQrView.data(
        data: '${[
          user.name,
          user.lastName,
          user.email,
          user.documentNumber,
          user.documentType,
          user.bloodType,
          user.fichaNumber,
          user.serviceCenter
        ]}',
        decoration: const PrettyQrDecoration(
          background: Colors.white,
          shape: PrettyQrSmoothSymbol(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          image: PrettyQrDecorationImage(
            image: AssetImage('images/logo_sena_negro.png'),
          ),
        ),
        errorCorrectLevel:
            QrErrorCorrectLevel.M, // Nivel de corrección de errores
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
