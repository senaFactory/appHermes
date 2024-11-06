import 'package:flutter/material.dart';

class EditEquiptModal {
  final TextEditingController _colorController;
  final Function(String) onSave;

  EditEquiptModal({required String initialColor, required this.onSave})
      : _colorController = TextEditingController(text: initialColor);

  // Método para mostrar el modal en el centro de la pantalla
  void showEditModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Cerrar el modal al tocar fuera
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Fondo blanco del modal
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Padding(
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
                // Campo para editar el color
                const Text(
                  'Color:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF39A900),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _colorController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Ingresa el nuevo color',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 20),
                // Botón para guardar el registro
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      onSave(_colorController
                          .text); // Llama a onSave con el nuevo color
                      Navigator.pop(context); // Cierra el modal
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
        );
      },
    );
  }
}
