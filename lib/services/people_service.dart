import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/models/user.dart';
import 'package:maqueta/models/equipment.dart';
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/providers/url_storage.dart';

class PeopleService {
  final String virtualPort = UrlStorage().virtualPort;
  final String urlInfoPerson = UrlStorage().urlCardPerson;
  TokenStorage tokenStorage = TokenStorage();

  Future<User?> getUserById(
      int? id, Future<Map<dynamic, dynamic>> token) async {
    var token = await tokenStorage.getToken();
    var decodeToken = await tokenStorage.decodeJwtToken();
    var document = decodeToken['sub'];

    final String baseUrl = '$virtualPort$urlInfoPerson';
    print(decodeToken);
    final url = Uri.parse('$baseUrl/card/$document');

    try {
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        print('Response from backend: $jsonResponse');

        if (jsonResponse.isNotEmpty) {
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
                userData['equipments']?.map((e) => Equipment.fromJson(e)) ??
                    []),
          );
        } else {
          throw Exception('User data not available');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user: $e');
      throw Exception('Error getting user data');
    }
  }
}
