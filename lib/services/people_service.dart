import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/models/user.dart';

class PeopleService {
  final String baseUrl = 'http://10.0.2.2:8081/api/v1/hermesapp/people';

  Future<User?> getUserById(int id) async {
    final url = Uri.parse('$baseUrl/by-id/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');  // Añadir esto para verificar la respuesta

        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['data'] != null && jsonResponse['data'].isNotEmpty) {
          final userData = jsonResponse['data'][0];

          return User(
            name: userData['name'],
            lastName: userData['lastname'],
            email: userData['email'],
            bloodType: userData['bloodType'],
            documentNumber: userData['document'].toString(),
            documentType: userData['documentType'],
            fichaNumber: '2620612',
            serviceCenter: 'Centro de Servicios Financieros',
            equipments: [],
          );
        } else {
          print('Datos del usuario no disponibles');
          throw Exception('Datos del usuario no disponibles');
        }
      } else {
        print('Error en el servidor: ${response.statusCode}');
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user: $e');
      throw Exception('Error al obtener datos del usuario');
    }
  }
}
