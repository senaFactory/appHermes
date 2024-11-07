import 'package:flutter/material.dart';
import 'package:maqueta/pages/carnet/qr_modal.dart';
import 'package:maqueta/widgets/home_app_bar.dart';
import 'package:maqueta/widgets/info_column.dart';
import 'package:maqueta/services/card_service.dart';
import 'package:maqueta/models/user.dart';

class Carnetpage extends StatefulWidget {
  const Carnetpage({super.key});

  @override
  State<Carnetpage> createState() => _CarnetpageState();
}

class _CarnetpageState extends State<Carnetpage> {
  final CardService _peopleService = CardService();
  Future<User?>? _userFuture; // Quitar "late" y usar un valor nulo inicial

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData();
  }

  Future<User?> _fetchUserData() async {
    return _peopleService.getUser();
  }

  Future<void> _refreshData() async {
    setState(() {
      _userFuture = _fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshData, // Llama a la función para recargar datos
        child: ListView(
          children: [
            const HomeAppBar(),
            FutureBuilder<User?>(
              future: _userFuture,
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
      width: screenSize.width * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 30),
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: user.photo != null
                ? MemoryImage(user.photo!)
                : const AssetImage('images/icono.jpg') as ImageProvider,
          ),
          const SizedBox(height: 15),
          Text(
            '${user.name.toUpperCase()} ${user.lastName.toUpperCase()}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF39A900),
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
          Text(
            user.program,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildQrButton(user),
          const SizedBox(height: 25),
          _buildUserDetails(user),
        ],
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
        _buildInfoRow(user.acronym, user.documentNumber, "RH", user.bloodType),
        const SizedBox(height: 15),
        _buildInfoRow(
            "Número Ficha", user.studySheet, "Centro", user.trainingCenter),
        const SizedBox(height: 15),
        _buildInfoRow("Jornada", user.journey, "Programa", user.program),
      ],
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
        backgroundColor: const Color(0xFF007D78),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
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
