import 'package:maqueta/models/equipment.dart';

class User {
  final String name;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String bloodType;
  final String documentNumber;
  final String documentType;
  final String fichaNumber;     // Número de ficha
  final String serviceCenter;   // Centro de servicios
  final List<Equipment> equipments;

  User({
    required this.name,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.bloodType,
    required this.documentNumber,
    required this.documentType,
    required this.fichaNumber,
    required this.serviceCenter,
    required this.equipments,
  });
}
