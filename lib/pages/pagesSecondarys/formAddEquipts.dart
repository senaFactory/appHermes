import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';

class Formaddequipts extends StatefulWidget {
  const Formaddequipts({super.key});

  @override
  State<Formaddequipts> createState() => _RegistroEquipoPageState();
}

class _RegistroEquipoPageState extends State<Formaddequipts> {
  // Controladores para los campos de texto
  final _tipoController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _numeroSerieController = TextEditingController();
  final _colorController = TextEditingController();

  // Lista de opciones para el tipo de equipo
  final List<String> _tiposDeEquipo = ['Tablet', 'Desktop', 'Portatil'];
  String? _tipoSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la página
            Text(
              'Registro de Equipo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00314D),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Por favor completa la siguiente información.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            // Dropdown para seleccionar el tipo de equipo
            Text(
              'Tipo de Equipo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00314D),
              ),
            ),
            DropdownButtonFormField<String>(
              value: _tipoSeleccionado,
              hint: Text('Selecciona el tipo de equipo'),
              items: _tiposDeEquipo.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _tipoSeleccionado = newValue;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            // Campo de texto para la marca
            _buildTextField('Marca', 'Selecciona la marca del equipo', _marcaController),
            SizedBox(height: 20),
            // Campo de texto para el modelo
            _buildTextField('Modelo', 'Ingresa el modelo del equipo', _modeloController),
            SizedBox(height: 20),
            // Campo de texto para el número de serie
            _buildTextField('Numero de serie', 'Ingresa el numero de serie del equipo', _numeroSerieController),
            SizedBox(height: 20),
            // Campo de texto para el color
            _buildTextField('Color', 'Ingresa el color del equipo', _colorController),
            SizedBox(height: 30),
            // Botón de registro
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para registrar el equipo
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00314D),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Registrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir los campos de texto
  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00314D),
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          ),
        ),
      ],
    );
  }
}
