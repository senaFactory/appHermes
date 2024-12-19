import 'package:flutter/material.dart';
import 'package:maqueta/services/auth_service.dart';
import 'package:maqueta/util/constans.dart';

void showPasswordRecoveryModal(BuildContext context) {
  String? documentType = AppConstants.documentType.first;
  final TextEditingController documentController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Center(
          child: Text(
            'Recuperar Contraseña',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown para el tipo de documento
              Text(
                'Tipo de Documento',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: documentType,
                onChanged: (String? newValue) {
                  documentType = newValue!;
                },
                decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  border: Theme.of(context).inputDecorationTheme.border,
                ),
                items: AppConstants.documentType
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value.trim(),
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 15),
              // Campo de entrada para el número de documento
              Text(
                'Número de Documento',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: documentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Introduce tu número de documento',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  border: Theme.of(context).inputDecorationTheme.border,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.all(10),
        actions: [
          // Botón de cancelar
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              textStyle: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
            child: const Text('Cancelar'),
          ),
          // Botón de recuperar
          ElevatedButton(
            onPressed: () async {
              if (documentController.text.isNotEmpty) {
                try {
                  int document = int.parse(documentController.text);

                  // Llama al servicio para recuperar contraseña
                  await AuthService().recoveryPassword(document);

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              'Se inició el proceso de recuperación correctamente.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              'Error al iniciar la recuperación de contraseña.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Por favor, ingresa un número de documento válido.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.white),
            ),
            child: const Text(
              'Recuperar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
