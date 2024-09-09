import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';

class Formaddeequipts extends StatefulWidget {
  const Formaddeequipts({super.key});

  @override
  State<Formaddeequipts> createState() => _RegistroEquipoPageState();
}

class _RegistroEquipoPageState extends State<Formaddeequipts> {
  // Lista de opciones para el tipo de equipo
  final List<String> _equipmentTypes = ['Tablet', 'Desktop', 'Portatil'];
  String? _selectedType;

  // Lista de opciones para las marcas
  final List<String> _brands = ['Apple', 'Dell', 'HP', 'Asus', 'Acer', 'Lenovo'];
  String? _selectedBrand;

  // Controladores para los campos de texto
  final _modelController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _colorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              // HomeAppBar con la flecha de retroceso
              Stack(
                children: [
                  const HomeAppBar(),
                  Positioned(
                    top: 30,
                    left: 5,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      // Flecha para regresar a la pantalla anterior.
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de la página
                    const Text(
                      'Registro de Equipo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00314D),
                      ),
                    ),
                    const Text(
                      'Por favor completa la siguiente información.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Dropdown para seleccionar el tipo de equipo
                    const Text(
                      'Tipo de Equipo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00314D),
                      ),
                    ),
                    _buildCustomDropdown(
                      hint: 'Selecciona el tipo de equipo',
                      value: _selectedType,
                      items: _equipmentTypes,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedType = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Dropdown para seleccionar la marca
                    const Text(
                      'Marca',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00314D),
                      ),
                    ),
                    _buildCustomDropdown(
                      hint: 'Selecciona la marca del equipo',
                      value: _selectedBrand,
                      items: _brands,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedBrand = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Campo de texto para el modelo
                    _buildTextField('Modelo', 'Ingresa el modelo del equipo', _modelController),
                    const SizedBox(height: 20),
                    
                    // Campo de texto para el número de serie
                    _buildTextField('Numero de serie', 'Ingresa el numero de serie del equipo', _serialNumberController),
                    const SizedBox(height: 20),
                    
                    // Campo de texto para el color
                    _buildTextField('Color', 'Ingresa el color del equipo', _colorController),
                    const SizedBox(height: 30),
                    
                    // Botón de registro alineado a la derecha
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,  // Alinea el botón a la derecha
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Lógica para registrar el equipo
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00314D),
                            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Registrar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget para construir el Dropdown personalizado
  Widget _buildCustomDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      // Estilo del Dropdown
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
      icon: Icon(
        Icons.keyboard_arrow_down,  // Cambia el icono de la flecha hacia abajo
        color: Colors.grey.shade600,
      ),
      style: const TextStyle(
        color: Colors.black,  // Estilo del texto seleccionado
        fontSize: 16,
      ),
      dropdownColor: Colors.white,  // Color de fondo del desplegable
      isExpanded: true,  // Para que ocupe todo el ancho disponible
    );
  }

  // Método para construir los campos de texto
  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00314D),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          ),
        ),
      ],
    );
  }
}
