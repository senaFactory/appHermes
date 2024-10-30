import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maqueta/models/user.dart';
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/services/people_service.dart';
import 'package:maqueta/services/student_service.dart';
import 'package:maqueta/widgets/home_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image; // Almacena la imagen seleccionada
  final PeopleService _peopleService = PeopleService();
  final StudentService _studentService = StudentService();
  final TokenStorage tokenStorage = TokenStorage();

  // Obtener los datos del usuario desde el backend
  Future<User?> _fetchUserData() async {
    return await _peopleService.getUser();
  }

  // Seleccionar la imagen desde la galería
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        if (!pickedFile.path.endsWith('.jpg') &&
            !pickedFile.path.endsWith('.jpeg')) {
          _showErrorDialog(
              'Formato no válido', 'Selecciona una imagen en formato JPG.');
          return;
        }

        setState(() {
          _image = File(pickedFile.path); // Guardar la imagen seleccionada
        });

        _showMessage('Imagen seleccionada correctamente.');
      }
    } catch (e) {
      _showErrorDialog('Error', 'Hubo un problema al seleccionar la imagen.');
    }
  }

  // Guardar la imagen enviando la ruta al backend
  Future<void> _saveImage() async {
    if (_image == null) {
      _showErrorDialog(
          'No se ha seleccionado imagen', 'Por favor selecciona una imagen.');
      return;
    }

    try {
      final decodeToken = await tokenStorage.decodeJwtToken();
      final document =
          int.parse(decodeToken['sub']); // Obtener el documento del token

      await _studentService.sendImagePath(_image!.path, document);
      _showMessage('Imagen subida correctamente.');
    } catch (e) {
      _showErrorDialog('Error', 'Hubo un problema al subir la imagen.');
    }
  }

  // Mostrar un SnackBar con un mensaje
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Mostrar un diálogo de error
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
              const HomeAppBar(), // AppBar personalizada
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
                      child: Text('No se encontraron datos del usuario.',
                          style: TextStyle(color: Colors.grey)),
                    );
                  }

                  final user = snapshot.data!;

                  return Column(
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
                      _buildProfileHeader(
                          user), // Header con la foto e info básica
                      const SizedBox(height: 25),
                      _buildProfileInfo(user), // Información del usuario
                      const SizedBox(height: 20),
                      _buildSaveButton(), // Botón de guardar
                    ],
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

  // Header con la foto de perfil e información básica
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
                : null, // No imagen por defecto
            child: _image == null
                ? Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.white.withOpacity(0.7),
                  )
                : null, // Ícono si no hay imagen
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

  // Información del usuario (detalles adicionales)
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
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                  child:
                      _buildInfoColumn("Número de Celular", user.phoneNumber)),
              const SizedBox(width: 15),
              Expanded(child: _buildInfoColumn("RH", user.bloodType)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                  child: _buildInfoColumn("Número de Ficha", user.studySheet)),
              const SizedBox(width: 15),
              Expanded(child: _buildInfoColumn("Centro", user.trainingCenter)),
            ],
          ),
        ],
      ),
    );
  }

  // Componente de información individual
  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF39A900))),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: value,
          enabled: false,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // Botón de guardar
  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: ElevatedButton(
        onPressed: _saveImage, // Lógica para guardar la imagen
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF39A900),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: const Text("Guardar", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
