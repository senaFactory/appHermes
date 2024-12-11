import 'package:flutter/material.dart';

import 'package:maqueta/util/helpers/equipment_helper.dart';
import 'package:maqueta/widgets/home_app_bar.dart';
import 'package:maqueta/services/equipment_service.dart';

class AddEquipmentPage extends StatefulWidget {
  static const routename = 'addEquipment';
  const AddEquipmentPage({super.key});

  @override
  State<AddEquipmentPage> createState() => _RegisterEquipmentPageState();
}

enum FieldType { modelo, numeroSerie, color }

class _RegisterEquipmentPageState extends State<AddEquipmentPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  final List<String> _equipmentTypes = ['Tablet', 'Portátil'];
  String? _selectedType;
  final List<String> _brands = [
    'Apple',
    'Dell',
    'HP',
    'Asus',
    'Acer',
    'Lenovo',
    'Huawei',
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
                child: Form(
                  key: _formKey, // Assigning form key
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      _buildTextField(
                        'Modelo',
                        'Ingresa el modelo del equipo',
                        _modelController,
                        'El modelo es requerido.',
                        FieldType
                            .modelo, // <--- Agregar FieldType para el campo
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        'Número de serie',
                        'Ingresa el número de serie',
                        _serialNumberController,
                        'El número de serie es requerido.',
                        FieldType
                            .numeroSerie, // <--- Agregar FieldType para el campo
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        'Color',
                        'Ingresa el color del equipo',
                        _colorController,
                        'El color es requerido.',
                        FieldType.color, // <--- Agregar FieldType para el campo
                      ),
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
                                borderRadius: BorderRadius.circular(20),
                              ),
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
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
        dropdownColor: Colors.white, // Cambiar el fondo a blanco puro
        hint: Text('Selecciona $label'),
        value: selectedValue,
        onChanged: onChanged,
        validator: (value) =>
            value == null ? 'Por favor selecciona $label.' : null,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    ],
  );
}

  Widget _buildTextField(
      String label,
      String hint,
      TextEditingController controller,
      String validationMessage,
      FieldType fieldType) {
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validationMessage;
            }

            switch (fieldType) {
              case FieldType.modelo:
                if (value.length < 2 ||
                    !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                  return "El modelo debe tener al menos 2 caracteres y solo letras o números.";
                }
                break;
              case FieldType.numeroSerie:
                if (value.length < 5 ||
                    !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                  return "El número de serie debe tener al menos 5 caracteres y solo letras o números.";
                }
                break;
              case FieldType.color:
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return "El color solo puede contener letras.";
                }
                break;
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _saveEquipment() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final newEquipment = EquipmentHelper.buildEquipment(
        brand: _selectedBrand!,
        model: _modelController.text,
        color: _colorController.text,
        serial: _serialNumberController.text,
      );

      Navigator.pop(context, newEquipment);

      try {
        await EquipmentHelper.submitEquipment(newEquipment, _equipmentService);
        if (mounted) {
          EquipmentHelper.showAlertDialog(
              context, 'Éxito', 'El equipo ha sido registrado correctamente.');
        }
      } catch (e) {
        if (mounted) {
          EquipmentHelper.showAlertDialog(context, 'Error',
              'Error al registrar el equipo. Inténtalo nuevamente.');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      EquipmentHelper.showAlertDialog(context, 'Campos incompletos',
          'Por favor completa todos los campos.');
    }
  }
}
