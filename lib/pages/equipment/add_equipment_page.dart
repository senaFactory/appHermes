import 'package:flutter/material.dart';
import 'package:maqueta/widgets/home_app_bar.dart';
import 'package:maqueta/widgets/custom_dropdown.dart';
import 'package:maqueta/models/equipment.dart';
import 'package:maqueta/services/equipment_service.dart';

class Formaddeequipts extends StatefulWidget {
  const Formaddeequipts({super.key});

  @override
  State<Formaddeequipts> createState() => _RegisterEquipmentPageState();
}

class _RegisterEquipmentPageState extends State<Formaddeequipts> {
  final List<String> _equipmentTypes = ['Tablet', 'Portátil'];
  String? _selectedType;
  final List<String> _brands = [
    'Apple',
    'Dell',
    'HP',
    'Asus',
    'Acer',
    'Lenovo'
  ];
  String? _selectedBrand;

  final _modelController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _colorController = TextEditingController();

  final EquipmentService _equipmentService = EquipmentService();
  bool _isLoading = false;

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
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                        color: Color(0xFF39A900),
                      ),
                    ),
                    const Text(
                      'Por favor completa la siguiente información.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    _buildDropdown(
                        'Tipo de Equipo', _equipmentTypes, _selectedType,
                        (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    }),
                    const SizedBox(height: 20),
                    _buildDropdown('Marca', _brands, _selectedBrand, (value) {
                      setState(() {
                        _selectedBrand = value;
                      });
                    }),
                    const SizedBox(height: 20),
                    _buildTextField('Modelo', 'Ingresa el modelo del equipo',
                        _modelController),
                    const SizedBox(height: 20),
                    _buildTextField('Número de serie',
                        'Ingresa el número de serie', _serialNumberController),
                    const SizedBox(height: 20),
                    _buildTextField('Color', 'Ingresa el color del equipo',
                        _colorController),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _isLoading ? null : _saveEquipment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF39A900),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Registrar',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
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

  Widget _buildDropdown(String label, List<String> items, String? selectedValue,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF39A900)),
        ),
        const SizedBox(height: 8),
        CustomDropdown(
          hint: 'Selecciona $label',
          value: selectedValue,
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF39A900)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          ),
        ),
      ],
    );
  }

  Future<void> _saveEquipment() async {
    if (_selectedType != null && _selectedBrand != null) {
      setState(() {
        _isLoading = true;
      });

      final newEquipment = Equipment(
        id: 0,
        personId: 1,
        brand: _selectedBrand!,
        model: _modelController.text,
        color: _colorController.text,
        serial: _serialNumberController.text,
        state: true,
      );

      try {
        await _equipmentService.addEquipment(newEquipment);
        _showAlertDialog(
            'Éxito', 'El equipo ha sido registrado correctamente.');
        Navigator.of(context).pop(newEquipment);
      } catch (e) {
        _showAlertDialog(
            'Error', 'Error al registrar el equipo. Inténtalo nuevamente.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _showAlertDialog(
          'Campos incompletos', 'Por favor completa todos los campos.');
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
