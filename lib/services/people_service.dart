import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/models/user.dart';
import 'package:maqueta/models/equipment.dart';
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/providers/url_storage.dart';
import 'package:maqueta/services/equipment_service.dart';

class PeopleService {
  final String virtualPort = UrlStorage().virtualPort;
  final String urlInfoPerson = UrlStorage().urlCardPerson;
  final EquipmentService _equipmentService = EquipmentService();
  final TokenStorage tokenStorage = TokenStorage();

  Future<User?> getUser() async {
    var token = await tokenStorage.getToken();
    var decodeToken = await tokenStorage.decodeJwtToken();
    var document = decodeToken['sub'];

    final String baseUrl = '$virtualPort$urlInfoPerson';
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
        print("paso codigo 22");
        if (jsonResponse.isNotEmpty) {
          final userData = jsonResponse;

          List<int> equipmentIds =
              List<int>.from(userData['equipments']?.map((e) => e['id']) ?? []);
          print("ids de equipos");
          List<Equipment> equipmentList =
              await _equipmentService.fetchEquipments(equipmentIds);
          print(userData);
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
              equipments: equipmentList,
              photo: userData['photo'] != null
                  ? base64Decode(userData['photo'])
                  : null);
        } else {
          throw Exception('User data not available');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error getting user data');
    }
  }
}
