import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/models/user.dart';
import 'package:maqueta/models/equipment.dart';

class PeopleService {
  final String baseUrl =
      'https://hhj97mdq-8081.use2.devtunnels.ms/api/v1/hermes/view/card/1';

  Future<User?> getUserById(int id, String token) async {  // El token ahora se pasa como parámetro
    final url = Uri.parse('$baseUrl');

    try {
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Incluye el token en los headers
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        print('Response from backend: $jsonResponse');

        if (jsonResponse != null && jsonResponse.isNotEmpty) {
          final userData = jsonResponse;

          return User(
            name: userData['name'] ?? 'N/A',
            lastName: userData['lastname'] ?? 'N/A',
            email: userData['email'] ?? 'N/A',
            phoneNumber: userData['phone'] ?? 'N/A',
            bloodType: userData['bloodType']?.trim() ?? 'N/A',
            documentNumber: userData['document'].toString(),
            acronym: userData['acronym'] ?? 'N/A',
            studySheet: userData['studySheet']?.toString() ?? '1231232',
            program: userData['program'] ?? 'N/A',
            journal: userData['journal'] ?? 'Tarde',
            trainingCenter: userData['trainingCenter'] ?? 'CSF',
            equipments: List<Equipment>.from(
                userData['equipments']?.map((e) => Equipment.fromJson(e)) ?? []),
          );
        } else {
          throw Exception('Datos del usuario no disponibles');
        }
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user: $e');
      throw Exception('Error al obtener datos del usuario');
    }
  }  
}
