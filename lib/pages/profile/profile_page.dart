import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/services/people_service.dart';
import 'package:maqueta/models/user.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:maqueta/services/student_service.dart';
import 'package:maqueta/widgets/home_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final PeopleService _peopleService = PeopleService();
  final StudentService _studentService = StudentService();
  final TokenStorage tokenStorage = TokenStorage();
  // Obtener datos del usuario a partir del token JWT
  Future<User?> _fetchUserData() async {
    return await _peopleService.getUser();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final decodeToken = await tokenStorage.decodeJwtToken();
    final document = int.parse(decodeToken['sub']);
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (!pickedFile.path.endsWith('.jpg') &&
          !pickedFile.path.endsWith('.jpeg')) {
        _showErrorDialog(
            'Formato no válido', 'Selecciona una imagen en formato JPG.');
        return;
      }

      Uint8List imageBytes = await pickedFile.readAsBytes();
      Uint8List documentBytes = Uint8List(4)
        ..buffer.asByteData().setInt32(0, document);
      Uint8List finalBytes =
          Uint8List.fromList([...documentBytes, ...imageBytes]);
      String base64Image = base64Encode(finalBytes);

      await _studentService.sendImage(base64Image);
    }
  }

  // Mostrar un diálogo de error si el formato es incorrecto
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              const HomeAppBar(),
              const SizedBox(height: 20),
              FutureBuilder<User?>(
                future: _fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error al cargar los datos: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'No se encontraron datos del usuario.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final user = snapshot.data!;

                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          "Mi Perfil",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF39A900),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildProfileHeader(user),
                        const SizedBox(height: 25),
                        _buildProfileInfo(user),
                        const SizedBox(height: 20),
                        _buildSaveButton(user),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          Positioned(
            top: 55,
            left: 5,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 25),
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 70,
            backgroundImage: _image != null
                ? FileImage(_image!)
                : const AssetImage('images/aprendiz_sena1.jpeg')
                    as ImageProvider,
            child: _image == null
                ? Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.white.withOpacity(0.7),
                  )
                : null,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${user.name} ${user.lastName}",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2B2B30),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  color: const Color(0xFF888787),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildInfoColumn("Nombres", user.name)),
              const SizedBox(width: 15),
              Expanded(child: _buildInfoColumn("Apellidos", user.lastName)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                  child: _buildInfoColumn("Tipo de Documento", user.acronym)),
              const SizedBox(width: 15),
              Expanded(
                  child: _buildInfoColumn(
                      "Número de Documento", user.documentNumber)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF39A900),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: value,
          enabled: false,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(User user) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () => {}, //_uploadImage(user),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF39A900),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              "Guardar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
