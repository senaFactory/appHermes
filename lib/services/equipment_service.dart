import 'dart:async';
import 'dart:convert';
import 'package:maqueta/models/equipment.dart';
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/providers/url_storage.dart';
import 'package:maqueta/services/network_service.dart';

class EquipmentService {
  final UrlStorage urlStorage = UrlStorage();
  final TokenStorage tokenStorage = TokenStorage();
  final NetworkService _networkService = NetworkService();

  Future<dynamic> addEquipment(Equipment equipment, Map<dynamic, dynamic> token) async {
    try {
      var authToken = await tokenStorage.getToken();
      var decodeToken = await tokenStorage.decodeJwtToken();
      var document = decodeToken['sub'];

      equipment.setDocumentId = document;

      // Construir el payload que el backend espera
      final Map<String, dynamic> data = {
        'brand': equipment.brand,
        'serial': equipment.serial,
        'model': equipment.model,
        'color': equipment.color,
        // backend en add usa getString("state") -> enviar como string
        'state': equipment.state.toString(),
        // location en add se fija en false por backend, pero lo enviamos acorde al modelo
        'location': equipment.location,
        'person': {'document': document}
      };

      final Map<String, dynamic> payload = {'data': data};

      final response = await _networkService.makeRequest(
        '${urlStorage.urlEquipment}/add',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        },
        body: payload,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Equipment>> fetchEquipments(List<int> equipmentIds) async {
    var token = await tokenStorage.getToken();

    try {
      var futures = equipmentIds.map((id) async {
        try {
          final response = await _networkService.makeRequest(
            '${urlStorage.urlEquipment}/by-id/$id',
            method: 'GET',
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );

          if (response != null && response['data'] != null) {
            return Equipment.fromJson(response['data']);
          }
          return null;
        } catch (e) {
          return null;
        }
      });

      var results = await Future.wait(futures);
      return results.where((equipment) => equipment != null).cast<Equipment>().toList();
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> editEquipment(Equipment equipment) async {
    try {
      var token = await tokenStorage.getToken();
      var decodeToken = await tokenStorage.decodeJwtToken();
      var document = decodeToken['sub'];
      equipment.setDocumentId = document;

      // Construir payload consistente con update del backend
      final Map<String, dynamic> data = {
        'brand': equipment.brand,
        'serial': equipment.serial,
        'model': equipment.model,
        'color': equipment.color,
        // backend en update usa getString("state") -> enviar como string
        'state': equipment.state.toString(),
        'location': equipment.location,
        'person': {'document': document}
      };

      final Map<String, dynamic> payload = {'data': data};

      final response = await _networkService.makeRequest(
        '${urlStorage.urlEquipment}/update/${equipment.id}',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: payload,
      );

      return response;
    } catch (e) {
      throw Exception('Error al editar el equipo: $e');
    }
  }

  Future<void> toggleEquipmentState(Equipment equipment) async {
    // Cambia el estado localmente (de activo a inactivo o viceversa)
    equipment.state = equipment.state == true ? false : true;

    // Realiza una actualización en el backend con el nuevo estado
    await editEquipment(equipment);
  }
}
