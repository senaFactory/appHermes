import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maqueta/services/student_service.dart';
import 'package:maqueta/widgets/home_app_bar.dart';
import 'package:maqueta/models/user.dart';
import 'package:maqueta/services/people_service.dart';
import 'package:maqueta/providers/token_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final StudentService _studentService = StudentService();
  final PeopleService _peopleService = PeopleService();
  final TokenStorage tokenStorage = TokenStorage();

  Future<User?> _fetchUserData() async {
    return await _peopleService.getUser();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print("mazocar2");
    print(ImageSource);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    try {
      if (_image == null) {
        _showMessage('No se ha seleccionado ninguna imagen.');
        return;
      }

      final decodeToken = await tokenStorage.decodeJwtToken();
      final document = int.parse(decodeToken['sub']);

      // Convertimos la imagen a Base64
      final bytes = await _image!.readAsBytes();
      final base64Image = base64Encode(bytes);
      print("mazorca");
      print(base64Image);

      // Enviamos la imagen al backend
      await _studentService.sendImageBase64(base64Image, document);

      _showMessage('Imagen subida correctamente.');
    } catch (e) {
      _showMessage('Error al subir la imagen: $e');
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mensaje'),
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
                        _buildSaveButton(),
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
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 70,
        backgroundImage: _image != null
            ? FileImage(_image!)
            : const AssetImage('images/aprendiz_sena1.jpeg') as ImageProvider,
        child: _image == null
            ? Icon(
                Icons.camera_alt,
                size: 30,
                color: Colors.white.withOpacity(0.7),
              )
            : null,
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _uploadImage,
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
    );
  }
}
