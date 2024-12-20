import 'package:flutter/material.dart';
import 'package:maqueta/pages/carnet/qr_modal.dart';
import 'package:maqueta/widgets/home_app_bar.dart';
import 'package:maqueta/services/card_service.dart';
import 'package:maqueta/models/user.dart';
import 'package:maqueta/widgets/info_column.dart';

class CarnetPage extends StatefulWidget {
  final String? role;

  const CarnetPage({required this.role, super.key});

  @override
  State<CarnetPage> createState() => _CarnetPageState();
}

class _CarnetPageState extends State<CarnetPage> {
  final CardService _cardService = CardService();
  Future<User?>? _userFuture;
  ImageProvider? _cachedPhoto;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData();
  }

  Future<User?> _fetchUserData() async {
    final user = await _cardService.getUser();
    if (user?.photo != null && user!.photo!.isNotEmpty) {
      try {
        _cachedPhoto = MemoryImage(user.photo!);
      } catch (e) {
        throw Exception('Error mostrando la foto');
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
      backgroundColor: Theme.of(context).colorScheme.secondary,
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
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }

  Widget _buildNoData() {
    return Center(
      child: Text(
        'No se encontraron datos del usuario.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
      ),
    );
  }

  Widget _buildCarnet(Size screenSize, User user) {
    return Container(
      width: screenSize.width * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 30),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.2),
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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            widget.role ?? 'N/A',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            (user.state ?? 'N/A').toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildQrButton(user),
          const SizedBox(height: 25),
          _buildUserDetails(user, widget.role),
        ],
      ),
    );
  }

  Widget _buildUserDetails(User user, String? role) {
    switch (role) {
      case "APRENDIZ":
        return _buildApprenticeDetails(user);
      case "COORDINATOR":
        return _buildCoordinatorDetails(user);
      case "ADMIN":
        return _buildAdminDetails(user);
      case "SEGURIDAD":
        return _buildSecurityDetails(user);
      case "INVITADO":
        return _buildGuestDetails(user);
      case "INSTRUCTOR":
        return _buildInstructorDetails(user);
      case "SUPER ADMIN":
        return _buildSuperAdminDetails(user);
      default:
        throw Exception('ROL NO EXISTE');
    }
  }

  Widget _buildSuperAdminDetails(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          "Tipo Documento (${user.acronym})",
          user.documentNumber,
          "RH",
          user.bloodType,
        ),
        const SizedBox(height: 10),
        _buildInfoRow(
          "Correo",
          user.email,
          "Teléfono",
          user.phoneNumber,
        ),
      ],
    );
  }

  Widget _buildApprenticeDetails(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'ESTADO: ${(user.state ?? 'N/A').toUpperCase()}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        _buildInfoRow(
          "Tipo Documento (${user.acronym})",
          user.documentNumber,
          "RH",
          user.bloodType,
        ),
        const SizedBox(height: 10),
        _buildInfoRow(
            "Número de Ficha", user.studySheet, "Centro", user.trainingCenter),
        const SizedBox(height: 10),
        _buildInfoRow("Jornada", user.journey, "Programa", user.program),
      ],
    );
  }

  Widget _buildAdminDetails(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          "Tipo Documento (${user.acronym})",
          user.documentNumber,
          "RH",
          user.bloodType,
        ),
        const SizedBox(height: 10),
        _buildInfoRow(
          "Posición",
          user.position ?? "N/A",
          "Correo",
          user.email,
        ),
        const SizedBox(height: 15),
        _buildInfoRow(
          "Teléfono",
          user.phoneNumber,
          "Centro",
          user.trainingCenter,
        ),
      ],
    );
  }

  Widget _buildCoordinatorDetails(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          "Tipo Documento (${user.acronym})",
          user.documentNumber,
          "RH",
          user.bloodType,
        ),
        const SizedBox(height: 10),
        _buildInfoRow(
          "Coordinación",
          user.coordination ?? "N/A",
          "Correo",
          user.email,
        ),
        const SizedBox(height: 15),
        _buildInfoRow(
          "Teléfono",
          user.phoneNumber,
          "Centro",
          user.trainingCenter,
        ),
      ],
    );
  }

  Widget _buildSecurityDetails(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          "Tipo Documento (${user.acronym})",
          user.documentNumber,
          "RH",
          user.bloodType,
        ),
        const SizedBox(height: 10),
        _buildInfoRow(
          "Centro de Formación",
          user.trainingCenter,
          "Sede",
          user.headquarter ?? "N/A",
        ),
        const SizedBox(height: 15),
        _buildInfoRow(
          "Identificación",
          user.documentNumber,
          "Teléfono",
          user.phoneNumber,
        ),
      ],
    );
  }

  Widget _buildGuestDetails(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          "Tipo Documento (${user.acronym})",
          user.documentNumber,
          "RH",
          user.bloodType,
        ),
        const SizedBox(height: 10),
        _buildInfoRow(
          "Evento",
          user.event?.join(", ") ?? "N/A",
          "Sede",
          user.headquarter ?? "N/A",
        ),
        const SizedBox(height: 15),
        _buildInfoRow(
          "Centro(s)",
          user.trainingCenters?.join(", ") ?? "N/A",
          "Correo",
          user.email,
        ),
      ],
    );
  }

  Widget _buildInstructorDetails(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          "Tipo Documento (${user.acronym})",
          user.documentNumber,
          "RH",
          user.bloodType,
        ),
        const SizedBox(height: 10),
        _buildInfoRow(
          "Coordinación",
          user.coordination ?? "N/A",
          "Correo",
          user.email,
        ),
        const SizedBox(height: 15),
        _buildInfoRow(
          "Teléfono",
          user.phoneNumber,
          "Centro",
          user.trainingCenter,
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      String label1, String value1, String label2, String value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InfoColumnWidget(
            label: label1,
            value: value1,
          ),
        ),
        Expanded(
          child: InfoColumnWidget(
            label: label2,
            value: value2,
          ),
        ),
      ],
    );
  }

  Widget _buildQrButton(User user) {
    return ElevatedButton.icon(
      onPressed: () => _showQrModal(user),
      icon:
          Icon(Icons.qr_code, color: Theme.of(context).colorScheme.onSecondary),
      label: Text(
        "Mostrar QR",
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
}
