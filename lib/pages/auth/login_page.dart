import 'package:flutter/material.dart';
import 'package:maqueta/models/auth_login.dart';
import 'package:maqueta/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();
  String dropdownValue =
      'Cedula de Ciudadania'; // Valor por defecto para el tipo de documento

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        fontSize: 16, color: Colors.black); // Estilo base para todo el texto

    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background.webp"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logotipo de SENA
                  Image.asset('images/LogoSena.png', height: 100),
                  const SizedBox(height: 20),

                  // Texto de bienvenida
                  const Text(
                    "Transformando vidas, construyendo futuro.",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Dropdown para seleccionar el tipo de documento con ícono
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.article,
                            color: Colors.grey), // Ícono del dropdown
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              isExpanded: true,
                              style:
                                  textStyle, // Aquí se aplica el mismo estilo que el resto
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>[
                                'Cedula de Ciudadania',
                                'Tarjeta de Identidad',
                                'Cedula de Extranjeria',
                                'Pasaporte',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style:
                                          textStyle), // Estilo del texto del menú
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo de texto para el número de documento
                  TextField(
                    controller: _documentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Número de documento',
                      prefixIcon: const Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style:
                        textStyle, // Aplica el mismo estilo al campo de texto
                  ),
                  const SizedBox(height: 20),

                  // Campo de texto para la contraseña
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style:
                        textStyle, // Aplica el mismo estilo al campo de texto
                  ),
                  const SizedBox(height: 20),

                  // Checkbox "Recordar" y enlace "¿Olvidó su contraseña?"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Implementar funcionalidad para olvidar contraseña
                        },
                        child: const Text(
                          '¿Olvidó su contraseña?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Botón de Iniciar Sesión
                  ElevatedButton(
                    onPressed: () async {
                      // Implementar la lógica de inicio de sesión
                      try {
                        int document = 88247916;
                        String password = "88247916I";

                        AuthLogin authResponse =
                            await authService.logIn(document, password);
                        // Navegar a HomeScreen
                        Navigator.pushReplacementNamed(context, '/home');
                      } catch (e) {
                        // Manejar el error, mostrar mensaje
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF39A900),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Iniciar Sesión",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
