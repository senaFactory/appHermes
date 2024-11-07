import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maqueta/services/student_service.dart';
import 'package:maqueta/widgets/home_app_bar.dart';
import 'package:maqueta/models/user.dart';
import 'package:maqueta/services/card_service.dart';
import 'package:maqueta/providers/token_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  bool _isLoading = false; // Controla el estado de carga
  final StudentService _studentService = StudentService();
  final CardService _peopleService = CardService();
  final TokenStorage tokenStorage = TokenStorage();

  Future<User?> _fetchUserData() async {
    return await _peopleService.getUser();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (!pickedFile.path.endsWith('.jpg') &&
          !pickedFile.path.endsWith('.jpeg')) {
        _showMessage('Por favor selecciona una imagen en formato JPG.');
        return;
      }
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      _showMessage('No se ha seleccionado ninguna imagen.');
      return;
    }
    setState(() {
      _isLoading = true; // Inicia la carga
    });

    try {
      final decodeToken = await tokenStorage.decodeJwtToken();
      final document = int.parse(decodeToken['sub']);
      final bytes = await _image!.readAsBytes();
      final base64Image = base64Encode(bytes);

      await _studentService.sendImageBase64(base64Image, document);

      setState(() {
        // Refrescamos el avatar con la imagen subida
        _image = File(_image!.path);
      });

      _showMessage('Imagen subida correctamente.');
    } catch (e) {
      _showMessage('Error al subir la imagen: $e');
    } finally {
      setState(() {
        _isLoading = false; // Finaliza la carga
      });
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            message,
            style: const TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.green),
              ),
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
    ImageProvider? imageProvider;

    if (_image != null) {
      // Si el usuario seleccionó una nueva imagen, se usa esa imagen
      imageProvider = FileImage(_image!);
    } else if (user.photo != null && user.photo!.isNotEmpty) {
      // Si el backend devolvió una imagen en Uint8List, se convierte en MemoryImage
      imageProvider = MemoryImage(user.photo!);
    } else {
      // Imagen predeterminada en caso de que no haya ninguna imagen
      imageProvider = const AssetImage('images/icono.jpg');
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 25),
        GestureDetector(
          onTap:
              _pickImage, // Esta parte permite al usuario seleccionar una nueva imagen
          child: CircleAvatar(
            radius: 70,
            backgroundImage: imageProvider,
            child: _image == null && (user.photo == null || user.photo!.isEmpty)
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
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildInfoColumn("Fecha Nacimiento", 'N/A')),
              const SizedBox(width: 15),
              Expanded(child: _buildInfoColumn("Dirección", 'N/A')),
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

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : _uploadImage, // Bloquea el botón durante la carga
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF39A900),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: _isLoading // Cambia el texto por un indicador de carga
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Guardar",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }
}
