import 'dart:typed_data';
import 'package:maqueta/models/equipment.dart';

class User {
  final String name;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String bloodType;
  final String documentNumber;
  final String acronym;
  final String studySheet;
  final String program;
  final String journey;
  final String trainingCenter;
  final Uint8List? photo;
  final List<Equipment> equipments;

  User({
    required this.name,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.bloodType,
    required this.documentNumber,
    required this.acronym,
    required this.studySheet,
    required this.program,
    required this.journey,
    required this.trainingCenter,
    required this.equipments,
    this.photo,
  });
}
