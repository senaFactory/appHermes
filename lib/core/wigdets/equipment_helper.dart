import 'package:flutter/material.dart';
import 'package:maqueta/features/equipment/equipment.dart';
import 'package:maqueta/features/equipment/equipment_service.dart';
import 'package:maqueta/core/provider/token_storage.dart';

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
      Equipment equipment, EquipmentService equipmentService) async {
    final jwt = await TokenStorage().decodeJwtToken();
    await equipmentService.addEquipment(equipment, jwt);
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
