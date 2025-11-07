import 'package:flutter/material.dart';
import 'package:maqueta/models/equipment.dart';
import 'package:maqueta/services/equipment_service.dart';
import 'package:maqueta/providers/token_storage.dart';

class EquipmentHelper {
  static Equipment buildEquipment({
    String? document,
    required String name,
    required String brand,
    required String model,
    required String color,
    required String serial,
    bool location = false,
    bool state = true,
  }) {
    return Equipment(
      document: null,
      name: name,
      brand: brand,
      model: model,
      color: color,
      location: location,
      serial: serial,
      state: state,
    );
  }

  static Future<void> submitEquipment(
      Equipment equipment, EquipmentService equipmentService, BuildContext context) async {
    final jwt = await TokenStorage().decodeJwtToken();
    try {
      await equipmentService.addEquipment(equipment, jwt);

      // Mostrar mensaje de éxito si el backend devuelve algo indicativo
      showAlertDialog(context, 'Éxito', 'Equipo registrado correctamente.');
    } catch (e) {
      showAlertDialog(context, 'Error', 'No se pudo registrar el equipo: $e');
      rethrow;
    }
  }

  static void showAlertDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Theme.of(context).colorScheme.surface, // Fondo ajustado al tema
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .primary, // Color del título según el tema
                ),
          ),
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSecondary, // Color del texto según el tema
                ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Aceptar',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Color del botón según el tema
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
