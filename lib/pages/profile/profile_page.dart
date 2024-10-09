import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:maqueta/services/people_service.dart';
import 'package:maqueta/models/user.dart';
import 'package:maqueta/widgets/home_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _celularController = TextEditingController();
  final FocusNode _celularFocusNode = FocusNode();
  File? _image;
  final PeopleService _peopleService = PeopleService();

  Future<User?> _fetchUserData() async {
    return await _peopleService.getUserById(2);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _celularFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _celularController.dispose();
    _celularFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: Text(
                        'No se encontraron datos del usuario.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final user = snapshot.data!;
                  if (_celularController.text.isEmpty) {
                    _celularController.text = user.phoneNumber.isNotEmpty ? user.phoneNumber : '';
                  }

                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          "Mi Perfil",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00314D),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
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
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Expanded(child: _buildInfoColumn("Tipo de documento", user.documentType)),
                                  const SizedBox(width: 15),
                                  Expanded(child: _buildInfoColumn("Número de documento", user.documentNumber)),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(child: _buildInfoColumn("Número de celular", _celularController.text, isEditable: true)),
                                  const SizedBox(width: 15),
                                  Expanded(child: _buildInfoColumn("Tipo de sangre", user.bloodType)),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(child: _buildInfoColumn("Número de ficha", user.fichaNumber)),
                                  const SizedBox(width: 15),
                                  Expanded(child: _buildInfoColumn("Centro", user.serviceCenter)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  print('Nuevo número de celular: ${_celularController.text}');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00314D),
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
                        ),
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

  Widget _buildInfoColumn(String label, String value, {bool isEditable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF00314D),
          ),
        ),
        const SizedBox(height: 5),
        isEditable
            ? TextFormField(
                controller: _celularController,
                focusNode: _celularFocusNode,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            : TextFormField(
                controller: TextEditingController(text: value),
                enabled: false,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
      ],
    );
  }
}
