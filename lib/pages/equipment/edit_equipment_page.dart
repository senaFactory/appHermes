import 'package:flutter/material.dart';

class EditEquiptModal {
  final Map<String, TextEditingController> _controllers = {};
  final Function(Map<String, String>) onSave;

  EditEquiptModal({
    required Map<String, String> initialFields, // Campos dinámicos
    required this.onSave,
  }) {
    // Inicializar los controladores dinámicos
    for (var entry in initialFields.entries) {
      _controllers[entry.key] = TextEditingController(text: entry.value);
    }
  }

  // Método para mostrar el modal
  void showEditModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título del modal
                  const Center(
                    child: Text(
                      "Editar registro",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF39A900),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Actualizar información",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Generar dinámicamente los campos
                  ..._controllers.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key}:',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF39A900),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText:
                                'Ingresa el nuevo ${entry.key.toLowerCase()}',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),

                  // Botón para guardar
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final updatedValues = <String, String>{};
                        _controllers.forEach((key, controller) {
                          updatedValues[key] = controller.text;
                        });

                        onSave(updatedValues); // Devolver los nuevos valores
                        Navigator.pop(context); // Cerrar modal
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF39A900),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Guardar registro",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
