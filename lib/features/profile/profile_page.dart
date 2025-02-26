import 'dart:io';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'package:maqueta/features/profile/profile_service.dart';
import 'package:maqueta/features/profile/student_service.dart';

import 'package:maqueta/core/wigdets/home_app_bar.dart';
import 'package:maqueta/features/auth/user.dart';
import 'package:maqueta/features/carnet/card_service.dart';
import 'package:maqueta/core/provider/token_storage.dart';
import 'package:image/image.dart' as img;
import 'package:maqueta/core/util/app_theme.dart';
import 'package:maqueta/core/util/constans.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  User? _userData;
  bool _isLoading = false;
  String? _selectedBloodType;
  final StudentService _studentService = StudentService();
  final ProfileUpdateService _profileUpdateService;
  final CardService _peopleService = CardService();
  final TokenStorage tokenStorage = TokenStorage();
  final TextEditingController _dateBirthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Variables para almacenar los valores iniciales
  String? _initialBloodType;
  String? _initialDateBirth;
  String? _initialAddress;
  File? _initialImage;

  _ProfilePageState()
      : _profileUpdateService = ProfileUpdateService(StudentService());

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _peopleService.getUser();
      final student = await _studentService.getUserData();
      if (user != null) {
        setState(() {
          _userData = user;
          _dateBirthController.text = student.dateBirth;
          _addressController.text = student.address;
          _selectedBloodType = user.bloodType;

          // Guardar los valores iniciales
          _initialDateBirth = student.dateBirth;
          _initialAddress = student.address;
          _initialBloodType = user.bloodType;
          _initialImage = _image;
          _isLoading = false;
        });
      } else {
        _showMessage('No se encontraron datos del usuario.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showMessage('Error al cargar los datos');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<File?> _fixImageOrientation(File file) async {
    try {
      // Leer la imagen como bytes
      final bytes = await file.readAsBytes();

      // Decodificar la imagen usando el paquete `image`
      final originalImage = img.decodeImage(bytes);

      if (originalImage == null) return null;

      // Corregir la orientación usando los metadatos EXIF
      final fixedImage = img.bakeOrientation(originalImage);

      // Guardar la imagen corregida en un nuevo archivo temporal
      final fixedFile = File('${file.path}_fixed.jpg');
      await fixedFile.writeAsBytes(img.encodeJpg(fixedImage));
      return fixedFile;
    } catch (e) {
      _showMessage('Error al corregir la orientación');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Tomar una foto',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                onTap: () async {
                  try {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.camera);
                    Navigator.of(context).pop(); // Cierra el modal

                    if (pickedFile == null) {
                      _showMessage('No se seleccionó ninguna imagen.');
                      return;
                    }

                    if (!pickedFile.path.endsWith('.jpg') &&
                        !pickedFile.path.endsWith('.jpeg')) {
                      _showMessage(
                          'Por favor selecciona una imagen en formato JPG o JPEG.');
                      return;
                    }

                    // Corregir la orientación
                    final correctedFile =
                        await _fixImageOrientation(File(pickedFile.path));

                    if (correctedFile == null) {
                      _showMessage('No se pudo corregir la imagen.');
                      return;
                    }

                    setState(() {
                      _image = correctedFile;
                    });
                  } catch (e) {
                    // Manejo de errores genéricos
                    _showMessage(
                        'Ocurrió un error al seleccionar la imagen: $e');
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Seleccionar de galería',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                onTap: () async {
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  Navigator.of(context).pop(); // Cierra el modal
                  if (pickedFile != null) {
                    if (!pickedFile.path.endsWith('.jpg') &&
                        !pickedFile.path.endsWith('.jpeg')) {
                      _showMessage(
                          'Por favor selecciona una imagen en formato JPG o JPEG.');
                      return;
                    }
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    // Verificar si hay cambios usando el servicio
    if (!_profileUpdateService.hasChanges(
      currentImage: _image,
      initialImage: _initialImage,
      currentBloodType: _selectedBloodType,
      initialBloodType: _initialBloodType,
      currentDateBirth: _dateBirthController.text,
      initialDateBirth: _initialDateBirth!,
      currentAddress: _addressController.text,
      initialAddress: _initialAddress!,
    )) {
      _showMessage('No se han realizado cambios para guardar.');
      return;
    }

    setState(() {
      _isLoading = true; // Inicia la carga
    });

    try {
      final decodeToken = await tokenStorage.decodeJwtToken();
      final document = int.parse(decodeToken['sub']);

      // Llama al servicio para actualizar el perfil
      await _profileUpdateService.updateProfile(
        image: _image,
        initialImage: _initialImage,
        bloodType: _selectedBloodType!,
        dateBirth: _dateBirthController.text,
        address: _addressController.text,
        document: document,
      );

      _showMessage('Datos guardados correctamente.');

      // Actualizar los valores iniciales después de guardar
      setState(() {
        _initialImage = _image;
        _initialBloodType = _selectedBloodType;
        _initialDateBirth = _dateBirthController.text;
        _initialAddress = _addressController.text;
      });
    } catch (e) {
      _showMessage('Error al guardar los datos');
    } finally {
      setState(() {
        _isLoading = false; // Finaliza la carga
      });
    }
  }

  void _showMessage(String message) {
    if (!mounted) return; // Asegúrate de que el widget esté en pantalla
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context)
              .dialogBackgroundColor, // Fondo del diálogo según el tema
          content: Text(
            message,
            style: TextStyle(
              fontSize: 17,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color, // Color del texto según el tema
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary, // Color del texto del botón "OK" según el tema
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.darkTheme.copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: AppTheme.darkTheme.colorScheme.surface,
                    onPrimary: AppTheme.darkTheme.colorScheme
                        .primary, // Aseguramos que el texto en el botón sea blanco
                    surface: AppTheme.darkTheme.colorScheme.primary,
                    onSurface: Colors.white, // Texto en el calendario
                    secondary: AppTheme.darkTheme.colorScheme.secondary,
                  ),
                )
              : AppTheme.lightTheme.copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppTheme.lightTheme.colorScheme.primary,
                    onPrimary: Colors.white,
                    surface: AppTheme.lightTheme.colorScheme.surface,
                    onSurface: Colors.black, // Texto en el calendario
                    secondary: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateBirthController.text = "${picked.toLocal()}".split(' ')[0];
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
              // Indicador de carga o mensaje cuando no hay datos del usuario
              if (_isLoading)
                const Center(
                    child: CircularProgressIndicator()) // Indicador de carga
              else if (_userData == null)
                Center(
                  child: Text(
                    'No se encontraron datos del usuario.',
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color, // Usar el color del tema
                    ),
                  ),
                )
              else
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        "Mi Perfil",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .colorScheme
                              .primary, // Usamos el color primario del tema
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildProfileHeader(_userData!),
                      const SizedBox(height: 25),
                      _buildProfileInfo(_userData!),
                      const SizedBox(height: 20),
                      _buildSaveButton(),
                    ],
                  ),
                ),
            ],
          ),
          Positioned(
            top: 55,
            left: 5,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: Theme.of(context).iconTheme.color),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSpecificFields(User user, String? role) {
    switch (role) {
      case "APRENDIZ":
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: _buildInfoColumn(
                        "Número de Ficha", user.studySheet, false)),
                const SizedBox(width: 15),
                Expanded(
                    child:
                        _buildInfoColumn("Centro", user.trainingCenter, false)),
              ],
            ),
          ],
        );
      case "ADMIN":
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: _buildInfoColumn(
                        "Posición", user.position ?? "N/A", false)),
                const SizedBox(width: 15),
                Expanded(
                    child:
                        _buildInfoColumn("Centro", user.trainingCenter, false)),
              ],
            ),
          ],
        );
      case "COORDINADOR":
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: _buildInfoColumn(
                        "Coordinación", user.coordination ?? "N/A", false)),
                const SizedBox(width: 15),
                Expanded(
                    child:
                        _buildInfoColumn("Centro", user.trainingCenter, false)),
              ],
            ),
          ],
        );
      case "INSTRUCTOR":
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: _buildInfoColumn(
                        "Coordinación", user.coordination ?? "N/A", false)),
                const SizedBox(width: 15),
                Expanded(
                    child:
                        _buildInfoColumn("Centro", user.trainingCenter, false)),
              ],
            ),
          ],
        );
      case "SEGURIDAD":
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: _buildInfoColumn(
                        "Sede", user.headquarter ?? "N/A", false)),
                const SizedBox(width: 15),
                Expanded(
                    child:
                        _buildInfoColumn("Centro", user.trainingCenter, false)),
              ],
            ),
          ],
        );
      case "INVITADO":
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: _buildInfoColumn(
                        "Evento", user.event?.join(", ") ?? "N/A", false)),
                const SizedBox(width: 15),
                Expanded(
                    child: _buildInfoColumn("Centro(s)",
                        user.trainingCenters?.join(", ") ?? "N/A", false)),
              ],
            ),
          ],
        );
      case "SUPER ADMIN":
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildInfoColumn("Correo", user.email, false)),
                const SizedBox(width: 15),
                Expanded(
                    child:
                        _buildInfoColumn("Teléfono", user.phoneNumber, false)),
              ],
            ),
          ],
        );
      default:
        throw Exception('ROL NO EXISTE');
    }
  }

  Widget _buildProfileHeader(User user) {
    ImageProvider? imageProvider;

    // Validamos si la imagen seleccionada es válida
    if (_image != null) {
      imageProvider = FileImage(_image!);
    } else if (user.photo != null && user.photo!.isNotEmpty) {
      try {
        // Intentamos construir la imagen desde la memoria
        imageProvider = MemoryImage(user.photo!);
      } catch (e) {
        // Si ocurre algún error, usamos la imagen por defecto
        imageProvider = const AssetImage('images/icono.jpg');
      }
    } else {
      // Si no hay imagen válida, usamos la imagen por defecto
      imageProvider = const AssetImage('images/icono.jpg');
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 25),
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 70,
            backgroundImage: imageProvider,
            child: (_image == null &&
                    (user.photo == null ||
                        user.photo!.isEmpty ||
                        imageProvider == const AssetImage('images/icono.jpg')))
                ? Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Theme.of(context).iconTheme.color ??
                        Colors.white70, // Color según el tema
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
                  color: Theme.of(context).textTheme.titleLarge?.color ??
                      const Color(0xFF2B2B30), // Usar color del tema
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  color: Theme.of(context).textTheme.bodyMedium?.color ??
                      const Color(0xFF888787), // Usar color del tema
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
    Future<String> getRoleFromTokenStorage() async {
      final TokenStorage tokenStorage = TokenStorage();
      String? role = await tokenStorage.getPrimaryRole();
      return role ??
          "INVITADO"; // Retorna "INVITADO" si no hay un rol disponible
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildInfoColumn("Nombres", user.name, false)),
              const SizedBox(width: 15),
              Expanded(
                  child: _buildInfoColumn("Apellidos", user.lastName, false)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                  child: _buildInfoColumn(
                      "Tipo de Documento", user.acronym, false)),
              const SizedBox(width: 15),
              Expanded(
                  child: _buildInfoColumn(
                      "Número de Documento", user.documentNumber, false)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                  child: _buildInfoColumn(
                      "Número de Celular", user.phoneNumber, false)),
              const SizedBox(width: 15),
              Expanded(child: _buildBloodTypeDropdown()),
            ],
          ),
          const SizedBox(height: 15),
          FutureBuilder<String>(
            future:
                getRoleFromTokenStorage(), // Obtener el rol de forma asíncrona
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Indicador de carga mientras se obtiene el rol
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Text("No se pudo obtener el rol");
              }

              String role = snapshot.data!;
              return _buildRoleSpecificFields(
                  user, role); // Renderizar campos específicos según el rol
            },
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      _selectDate(context), // Abre el selector de fecha
                  child: AbsorbPointer(
                    child: _buildInfoColumn(
                      "Fecha Nacimiento",
                      "",
                      true,
                      controller: _dateBirthController,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildInfoColumn(
                  "Dirección",
                  "",
                  true,
                  controller: _addressController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBloodTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RH',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context)
                .colorScheme
                .primary, // Usamos el color primario del tema
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: _selectedBloodType,
          items: AppConstants.bloodTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(
                type,
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .tertiary, // Usamos el color secundario
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedBloodType = value;
            });
          },
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .primary, // Borde usando el color primario
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .primary, // Borde cuando está habilitado
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .primary, // Borde cuando está enfocado
                width: 2.0,
              ),
            ),
          ),
          style: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .primary, // Usamos el color secundario para el texto
          ),
          dropdownColor:
              Theme.of(context).colorScheme.primary, // Fondo del dropdown
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value, bool editable,
      {TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context)
                .colorScheme
                .primary, // Usamos el color primario del tema
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller ?? TextEditingController(text: value),
          enabled: editable,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .primary, // Borde usando el color primario
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .primary, // Borde cuando está habilitado
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .primary, // Borde cuando está enfocado
                width: 2.0,
              ),
            ),
            hintText: label == "Fecha Nacimiento"
                ? "Selecciona tu fecha"
                : "Ingresa tu dirección",
            hintStyle: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color, // Usamos el color del texto del tema
            ),
          ),
          style: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .tertiary, // Usamos el color secundario para el texto
          ),
          readOnly: label ==
              "Fecha Nacimiento", // Solo lectura para Fecha de Nacimiento
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
            onPressed: _isLoading ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .primary, // Usamos el color primario del tema
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Guardar",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
          ),
        ],
      ),
    );
  }
}
