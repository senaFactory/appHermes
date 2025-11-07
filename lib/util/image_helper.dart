import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

class ImageHelper {
  static const int maxSizeBytes = 1024 * 1024; // 1MB
  static const int targetWidth = 800;
  static const int targetHeight = 800;
  static const int targetQuality = 85;

  /// Comprime y redimensiona una imagen para asegurar que cumpla con los límites del servidor
  static Future<List<int>> processImageForUpload(File imageFile) async {
    try {
      // Primero intentamos con compresión básica
      var result = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        minWidth: targetWidth,
        minHeight: targetHeight,
        quality: targetQuality,
      );

      if (result == null) {
        throw Exception('Error al comprimir la imagen');
      }

      // Si aún es muy grande, reducimos más la calidad
      if (result.length > maxSizeBytes) {
        result = await FlutterImageCompress.compressWithFile(
          imageFile.absolute.path,
          minWidth: targetWidth ~/ 1.5,
          minHeight: targetHeight ~/ 1.5,
          quality: targetQuality ~/ 1.5,
        );

        if (result == null || result.length > maxSizeBytes) {
          throw Exception('La imagen es demasiado grande incluso después de la compresión');
        }
      }

      return result;
    } catch (e) {
      print('Error procesando imagen: $e');
      throw Exception('Error al procesar la imagen: $e');
    }
  }
}
