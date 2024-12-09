import 'package:flutter/material.dart';
import 'package:maqueta/pages/home_screen.dart';
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
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'Cédula de Ciudadanía';
  bool _isLoading = false;
  bool _obscureText = true;

  /// Mostrar un diálogo de error
  void mostrarErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Column(
              children: [
                Icon(
                  Icons.error,
                  color: const Color.fromRGBO(251, 7, 7, 1),
                  size: MediaQuery.of(context).size.width * 0.2,
                ),
                Text(
                  'Oops!',
                  style: TextStyle(
                      color: const Color.fromRGBO(251, 7, 7, 1),
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.width * 0.3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: const Color.fromRGBO(251, 7, 7, 1),
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Para más información, visita www.hermes.com',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 113, 119, 121),
                      fontSize: MediaQuery.of(context).size.width * 0.028,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 16, color: Colors.black);

    return Scaffold(
      body: Stack(
        children: [
          // Fondo
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
          // Formulario de inicio de sesión
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset('images/LogoSena.png', height: 100),
                    const SizedBox(height: 20),
                    const Text(
                      "Transformando vidas, construyendo futuro.",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    // Tipo de documento
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.article, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                isExpanded: true,
                                style: textStyle,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Cédula de Ciudadanía',
                                  'Tarjeta de Identidad',
                                  'Cédula de Extranjeria',
                                  'Permiso especial de permanencía',
                                  'Permiso de protección temporal',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: textStyle),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Campo de documento
                    TextFormField(
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
                      style: textStyle,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su número de documento';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Campo de contraseña
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: textStyle,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Botón de inicio de sesión
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  int document =
                                      int.parse(_documentController.text);
                                  String password = _passwordController.text;

                                  // Llamar al servicio de inicio de sesión
                                  final String role = await authService.logIn(
                                      document, password);

                                  // Navegar a la pantalla principal pasando el rol
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomeScreen(role: role),
                                    ),
                                  );
                                } catch (e) {
                                  if (mounted) {
                                    mostrarErrorDialog(
                                      context,
                                      'Credenciales incorrectas o rol no permitido. Por favor, inténtelo de nuevo.',
                                    );
                                  }
                                } finally {
                                  setState(() {
                                    _isLoading = false;
                                  });
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
