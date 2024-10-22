import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/models/user.dart';

class PeopleService {
  final String baseUrl = 'https://hhj97mdq-8081.use2.devtunnels.ms/api/v1/hermesapp/people';

  Future<User?> getUserById(int id) async {
    final url = Uri.parse('$baseUrl/by-id/$id');

    try {
      final response = await http.get(url);
      print(response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Imprime la respuesta completa para ver la estructura y los datos
        print('Response from backend: $jsonResponse');

        if (jsonResponse['data'] != null && jsonResponse['data'].isNotEmpty) {
          final userData = jsonResponse['data'][0];

          // Imprime específicamente el campo phoneNumber para verificarlo
          print('phoneNumber from API: ${userData['phoneNumber']}');

          return User(
            name: userData['name'] ?? 'N/A',
            lastName: userData['lastname'] ?? 'N/A',
            email: userData['email'] ?? 'N/A',
            phoneNumber: userData['phone'] ?? '',
            bloodType: userData['bloodType'] ?? 'N/A',
            documentNumber: userData['document'].toString(),
            documentType: userData['documentType'] ?? 'N/A',
            fichaNumber: userData['fichaNumber'] ?? '2620612', // Valor por defecto
            serviceCenter: userData['serviceCenter'] ?? 'Servicios Financieros', // Valor por defecto
            equipments: [], // Equipos vacíos por ahora
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
