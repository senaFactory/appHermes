import 'dart:convert';
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
  final String? headquarter;
  final List<String>? roles;
  final Uint8List? photo;
  final String? state;

  // Equipos desde el backend
  final List<Equipment> equipments;

  // Campos adicionales
  final String? position;
  final String? address;
  final String? dateBirth;
  final String? coordination;
  final List<String>? event;
  final List<String>? trainingCenters;

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
    this.state,
    this.headquarter,
    this.roles,
    this.photo,
    this.equipments = const [],
    this.position,
    this.address,
    this.dateBirth,
    this.coordination,
    this.event,
    this.trainingCenters,
  });

  /// Crea un objeto `User` desde un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? 'N/A',
      lastName: json['lastname'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      phoneNumber: json['phone'] ?? 'N/A',
      bloodType: json['bloodType']?.trim() ?? 'N/A',
      documentNumber: json['document'].toString(),
      acronym: json['acronym'] ?? 'N/A',
      studySheet: json['studySheet']?.toString() ?? 'N/A',
      program: json['program'] ?? 'N/A',
      journey: json['journey'] ?? 'N/A',
      state: json['state'] ?? 'N/A',
      roles: (json['roles'] as List<dynamic>?)?.cast<String>() ?? [],
      photo: json['photo'] != null ? base64Decode(json['photo']) : null,
      trainingCenter: json['trainingCenter'] ?? 'N/A',
      equipments: (json['equipments'] as List<dynamic>?)
              ?.map((e) => Equipment.fromJson(e))
              .toList() ??
          [],

      // Campos adicionales
      position: json['position'] ?? 'N/A',
      address: json['address'] ?? 'N/A',
      dateBirth: json['dateBirth'] ?? 'N/A',
      coordination: json['coordination'] ?? 'N/A',
      headquarter: json['headquarter'] ?? 'N/A',
      event: (json['event'] as List<dynamic>?)?.cast<String>() ?? [],
      trainingCenters:
          (json['trainingCenterList'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  /// Método `copyWith` para actualizar campos
  User copyWith({
    String? name,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? bloodType,
    String? documentNumber,
    String? acronym,
    String? studySheet,
    String? program,
    String? journey,
    String? trainingCenter,
    String? headquarter,
    String? state,
    List<String>? roles,
    Uint8List? photo,
    List<Equipment>? equipments,
    String? position,
    String? address,
    String? dateBirth,
    String? coordination,
    List<String>? event,
    List<String>? trainingCenters,
  }) {
    return User(
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bloodType: bloodType ?? this.bloodType,
      documentNumber: documentNumber ?? this.documentNumber,
      acronym: acronym ?? this.acronym,
      studySheet: studySheet ?? this.studySheet,
      program: program ?? this.program,
      journey: journey ?? this.journey,
      trainingCenter: trainingCenter ?? this.trainingCenter,
      headquarter: headquarter ?? this.headquarter,
      state: state ?? this.state,
      roles: roles ?? this.roles,
      photo: photo ?? this.photo,
      equipments: equipments ?? this.equipments,
      position: position ?? this.position,
      address: address ?? this.address,
      dateBirth: dateBirth ?? this.dateBirth,
      coordination: coordination ?? this.coordination,
      event: event ?? this.event,
      trainingCenters: trainingCenters ?? this.trainingCenters,
    );
  }

  /// Convierte el objeto `User` a un JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastname': lastName,
      'email': email,
      'phone': phoneNumber,
      'bloodType': bloodType,
      'document': documentNumber,
      'photo': photo != null ? base64Encode(photo!) : null,
      'acronym': acronym,
      'studySheet': studySheet,
      'program': program,
      'journey': journey,
      'roles': roles,
      'state': state,
      'trainingCenter': trainingCenter,
      'headquarter': headquarter,
      'equipments': equipments.map((e) => e.toJson()).toList(),
      'position': position,
      'address': address,
      'dateBirth': dateBirth,
      'coordination': coordination,
      'event': event,
      'trainingCenterList': trainingCenters,
    };
  }
}
