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
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título del modal
              Center(
                child: Text(
                  "Editar registro",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Center(
                child: Text(
                  "Actualizar información",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              const SizedBox(height: 20),

              // Generar dinámicamente los campos
              ..._controllers.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
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
                          hintStyle:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Botón para guardar
              const SizedBox(height: 10),
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Guardar registro",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
