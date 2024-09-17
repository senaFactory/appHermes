import 'dart:io'; // Para trabajar con archivos
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Importar el paquete image_picker
import 'package:maqueta/widgets/home_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controlador para el campo de número de celular (editable)
  final TextEditingController _celularController =
      TextEditingController(text: '3223909096');

  // Variable para almacenar la imagen seleccionada
  File? _image;

  // Método para seleccionar una imagen
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Método para construir cada columna con campos no editables
  Widget _buildInfoColumn(String label, String value,
      {bool isEditable = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF00314D),
            ),
          ),
          isEditable
              ? TextFormField(
                  controller: _celularController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              : TextFormField(
                  initialValue: value,
                  enabled:
                      false, // Deshabilita el campo para que no sea editable
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              const HomeAppBar(),
              const SizedBox(height: 20), // Espacio después de la AppBar
              Center(
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
                    // Foto de perfil y nombre con apellidos en una Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 25), // Espacio a la izquierda
                        GestureDetector(
                          onTap: _pickImage, // Cuando se toca la imagen, se abre la galería
                          child: CircleAvatar(
                            radius: 70, // Tamaño del círculo de la imagen del perfil
                            backgroundImage: _image != null
                                ? FileImage(_image!) // Si hay una imagen, la muestra
                                : const AssetImage('images/aprendiz_sena1.jpeg') as ImageProvider,
                            child: _image == null
                                ? Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                    color: Colors.white.withOpacity(0.7),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(
                            width: 20), // Espacio entre la imagen y el texto
                        // Column para alinear el nombre y correo a la derecha de la imagen
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // El texto se ajusta dinámicamente según el tamaño de la pantalla
                              Text(
                                "Juan Pedro Nalavaja Laverde",
                                style: TextStyle(
                                  fontSize: screenSize.width *
                                      0.04, // Tamaño relativo al ancho
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2B2B30),
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Corta con "..." si es muy largo
                              ),
                              const SizedBox(
                                  height:
                                      5), // Pequeño espacio entre nombre y correo
                              Text(
                                "juanPeNavaja@gmail.com",
                                style: TextStyle(
                                  fontSize: screenSize.width *
                                      0.03, // Tamaño relativo al ancho
                                  color: Color(0xFF888787),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row y Expanded para organizar la información en dos columnas.
                          Row(
                            children: [
                              _buildInfoColumn("Nombres", "Juan Pedro"),
                              const SizedBox(width: 15),
                              _buildInfoColumn("Apellidos", "Navaja Laverde"),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              _buildInfoColumn("Tipo de documento", "C.C"),
                              const SizedBox(width: 15),
                              _buildInfoColumn(
                                  "Número de documento", "1032937844"),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              // El número de celular es el único campo editable
                              _buildInfoColumn("Número de celular", "",
                                  isEditable: true),
                              const SizedBox(width: 15),
                              _buildInfoColumn("Tipo de sangre", "O +"),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              _buildInfoColumn("Fecha de nacimiento", "28/10/2000"),
                              const SizedBox(width: 15),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Botón de guardar alineado a la derecha con padding
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 20), // Espacio entre el botón y el borde derecho
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .end, // Alinea el botón a la derecha
                        children: [
                          ElevatedButton(
                            onPressed: () {

                              //TODO: Lógica para guardar los cambios (solo el número de celular)
                              
                              print('Nuevo número de celular: ${_celularController.text}');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00314D),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Guardar",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Funcionalidad de la flecha hacia atrás
          Positioned(
            top: 55,
            left: 5,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              // Botón para regresar a la pantalla anterior.
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
