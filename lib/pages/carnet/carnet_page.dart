import 'package:flutter/material.dart';
import 'package:maqueta/pages/carnet/qr_modal.dart';
import 'package:maqueta/widgets/home_app_bar.dart';
import 'package:maqueta/services/card_service.dart';
import 'package:maqueta/models/user.dart';

class Carnetpage extends StatefulWidget {
  final String role;

  const Carnetpage({required this.role, Key? key}) : super(key: key);

  @override
  State<Carnetpage> createState() => _CarnetpageState();
}

class _CarnetpageState extends State<Carnetpage> {
  final CardService _peopleService = CardService();
  Future<User?>? _userFuture;
  ImageProvider? _cachedPhoto;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData();
  }

  Future<User?> _fetchUserData() async {
    final user = await _peopleService.getUser();

    if (user?.photo != null && user!.photo!.isNotEmpty) {
      try {
        // Usa directamente el Uint8List para crear el MemoryImage
        _cachedPhoto = MemoryImage(user.photo!);
      } catch (e) {
        debugPrint("Error al procesar la imagen: $e");
      }
    }

    return user;
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
        onRefresh: _refreshData,
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
      padding: const EdgeInsets.all(40),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: _cachedPhoto ?? 
                const AssetImage('images/icono.jpg') as ImageProvider,
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
          Text(
            widget.role.replaceFirst("ROLE_", ""),
            style: const TextStyle(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
        },
        children: [
          _buildTableRow("C.C", user.documentNumber, "RH", user.bloodType),
          _buildTableRow(
              "Número Ficha", user.studySheet, "Centro", user.trainingCenter),
          _buildTableRow("Jornada", user.journey, "Programa", user.program),
        ],
      ),
    );
  }

  TableRow _buildTableRow(
      String label1, String value1, String label2, String value2) {
    return TableRow(
      children: [
        _buildTableCell(label1, value1),
        _buildTableCell(label2, value2),
      ],
    );
  }

  Widget _buildTableCell(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF39A900),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
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
        backgroundColor: const Color(0xFF007D78),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
