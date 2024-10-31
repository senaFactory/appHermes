import 'package:flutter/material.dart';
import 'package:maqueta/models/equipment.dart';
import 'package:maqueta/services/equipment_service.dart';
import 'package:maqueta/providers/token_storage.dart';

class EquipmentHelper {
  static Equipment buildEquipment({
    required String brand,
    required String model,
    required String color,
    required String serial,
    bool state = true,
  }) {
    return Equipment(
      document: null,
      brand: brand,
      model: model,
      color: color,
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
