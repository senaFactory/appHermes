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

enum FieldType { modelo, numeroSerie, color, tipo, marca }

class _RegisterEquipmentPageState extends State<AddEquipmentPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  // Controllers for text fields
  final _typeController = TextEditingController();
  final _brandController = TextEditingController();
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
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Por favor completa la siguiente información.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      // Tipo de Equipo
                      _buildTextField(
                        'Tipo de Equipo',
                        'Ingresa el tipo de equipo',
                        _typeController,
                        'El tipo de equipo es requerido.',
                        FieldType.tipo,
                      ),
                      const SizedBox(height: 20),
                      // Marca del equipo
                      _buildTextField(
                        'Marca',
                        'Ingresa la marca del equipo',
                        _brandController,
                        'La marca del equipo es requerida.',
                        FieldType.marca,
                      ),
                      const SizedBox(height: 20),
                      // Modelo
                      _buildTextField(
                        'Modelo',
                        'Ingresa el modelo del equipo',
                        _modelController,
                        'El modelo es requerido.',
                        FieldType.modelo,
                      ),
                      const SizedBox(height: 20),
                      // Número de serie
                      _buildTextField(
                        'Número de serie',
                        'Ingresa el número de serie',
                        _serialNumberController,
                        'El número de serie es requerido.',
                        FieldType.numeroSerie,
                      ),
                      const SizedBox(height: 20),
                      // Color
                      _buildTextField(
                        'Color',
                        'Ingresa el color del equipo',
                        _colorController,
                        'El color es requerido.',
                        FieldType.color,
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

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    String validationMessage,
    FieldType fieldType,
  ) {
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
              case FieldType.tipo:
              case FieldType.marca:
                if (value.length < 2 ||
                    !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return "Debe tener al menos 2 caracteres y solo letras.";
                }
                break;
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
        brand: _brandController.text,
        model: _modelController.text,
        color: _colorController.text,
        serial: _serialNumberController.text,
        name: _typeController.text,
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
