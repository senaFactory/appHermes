import 'package:maqueta/models/equipment.dart';

class User {
  final String name;
  final String lastName;
  final String documentType;
  final String documentNumber;
  final String bloodType;
  final String email;
  final String phoneNumber;
  final DateTime birthDate;
  final String fichaNumber;      //* Número de ficha
  final String trainingCenter;   //* Centro de formación
  final List<Equipment> equipments;  //* Equipos asociados al usuario

  User({
    required this.name,
    required this.lastName,
    required this.documentType,
    required this.documentNumber,
    required this.bloodType,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.fichaNumber,    //* Campo para número de ficha
    required this.trainingCenter, //* Campo para centro de formación
    required this.equipments,
  });
}
