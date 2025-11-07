import 'dart:convert';
import 'dart:io';
import 'package:maqueta/models/student.dart';
import 'package:maqueta/services/student_service.dart';
import 'package:maqueta/util/image_helper.dart';

class ProfileUpdateService {
  final StudentService _studentService;

  ProfileUpdateService(this._studentService);

  // Función para verificar si hay cambios en los datos del usuario
  bool hasChanges({
    required File? currentImage,
    required File? initialImage,
    required String? currentBloodType,
    required String? initialBloodType,
    required String currentDateBirth,
    required String initialDateBirth,
    required String currentAddress,
    required String initialAddress,
  }) {
    return currentImage != initialImage ||
        currentBloodType != initialBloodType ||
        currentDateBirth != initialDateBirth ||
        currentAddress != initialAddress;
  }

  // Función para subir los datos del usuario si hubo cambios
  Future<void> updateProfile({
    required File? image,
    required File? initialImage,
    required String bloodType,
    required String dateBirth,
    required String address,
    required int document,
  }) async {
    try {
      // Si la imagen cambió, procesarla y subirla
      if (image != null && image != initialImage) {
        // Procesar y comprimir la imagen
        final compressedImageBytes = await ImageHelper.processImageForUpload(image);
        final base64Image = base64Encode(compressedImageBytes);

        // Verificar el tamaño después de la codificación base64
        final sizeInMB = base64Image.length / (1024 * 1024);
        if (sizeInMB > 1) {
          throw Exception('La imagen es demasiado grande. Por favor, selecciona una imagen más pequeña (máximo 1MB).');
        }

        await _studentService.sendImageBase64(base64Image, document);
      }

      // Subir los otros datos (tipo de sangre, fecha de nacimiento, dirección)
      final updatedData = Student(
        dateBirth: dateBirth,
        bloodType: bloodType,
        address: address
      );

      await _studentService.updateStudentData(updatedData, document);
    } catch (e) {
      print('Error en updateProfile: $e');
      throw Exception('Error al actualizar el perfil: $e');
    }
  }
}
