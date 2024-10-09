import 'package:flutter/material.dart';
import 'package:maqueta/widgets/home_app_bar.dart';
import 'package:maqueta/widgets/custom_dropdown.dart'; 
import 'package:maqueta/models/equipment.dart';

class Formaddeequipts extends StatefulWidget {
  const Formaddeequipts({super.key});

  @override
  State<Formaddeequipts> createState() => _RegisterEquipmentPageState();
}

class _RegisterEquipmentPageState extends State<Formaddeequipts> {
  final List<String> _equipmentTypes = ['Tablet', 'Desktop', 'Portatil'];
  String? _selectedType;
  final List<String> _brands = ['Apple', 'Dell', 'HP', 'Asus', 'Acer', 'Lenovo'];
  String? _selectedBrand;

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
              Stack(
                children: [
                  const HomeAppBar(),
                  Positioned(
                    top: 30,
                    left: 5,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                    const Text(
                      'Tipo de Equipo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00314D),
                      ),
                    ),
                    CustomDropdown(
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
                    const Text(
                      'Marca',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00314D),
                      ),
                    ),
                    CustomDropdown(
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
                    _buildTextField('Modelo', 'Ingresa el modelo del equipo', _modelController),
                    const SizedBox(height: 20),
                    _buildTextField('Numero de serie', 'Ingresa el numero de serie del equipo', _serialNumberController),
                    const SizedBox(height: 20),
                    _buildTextField('Color', 'Ingresa el color del equipo', _colorController),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Crear un nuevo equipo con la información proporcionada
                            if (_selectedType != null && _selectedBrand != null) {
                              final newEquipment = Equipment(
                                type: _selectedType!,
                                brand: _selectedBrand!,
                                model: _modelController.text,
                                color: _colorController.text,
                                serialNumber: _serialNumberController.text,
                              );
                              Navigator.of(context).pop(newEquipment);
                            } else {
                              // Mostrar un mensaje de error si los campos están vacíos
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Por favor llena todos los campos.')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00314D),
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Registrar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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
