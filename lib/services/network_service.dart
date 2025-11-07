import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../providers/url_storage.dart';

class NetworkService {
  final UrlStorage urlStorage = UrlStorage();

  // Cliente HTTP personalizado que acepta certificados autofirmados
  HttpClient _createHttpClient() {
    final httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return httpClient;
  }

  Future<dynamic> makeRequest(String endpoint, {
    String method = 'GET',
    Map<String, String>? headers,
    dynamic body,
  }) async {
    headers ??= {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final response = await _attemptRequest(
        endpoint,
        method: method,
        headers: headers,
        body: body,
      );

      return _handleResponse(response);
    } catch (e) {
      // Rethrow para que el llamador maneje el error
      rethrow;
    }
  }

  // Normaliza la URL devuelta por UrlStorage.getUrl para evitar prefijos repetidos
  String _normalizeUrl(String rawUrl) {
    // Asegurar que sólo exista un 'api/api' si el backend espera ese prefijo
    return rawUrl.replaceAll(RegExp(r'(?:/api){2,}'), '/api/api');
  }

  Future<http.Response> _attemptRequest(String endpoint, {
    required String method,
    required Map<String, String> headers,
    dynamic body,
  }) async {
    // Construir URL y normalizar
    final raw = urlStorage.getUrl(endpoint);
    final normalized = _normalizeUrl(raw);
    final url = Uri.parse(normalized);

    final httpClient = _createHttpClient();

    try {
      final request = await httpClient.openUrl(method, url);

      // Agregar headers
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });

      // Agregar body si existe
      if (body != null) {
        final encodedBody = utf8.encode(json.encode(body));
        request.contentLength = encodedBody.length;
        request.add(encodedBody);
      }

      final httpResponse = await request.close();

      // Si hay redirección, seguirla manualmente (resuelve doble prefijo)
      if (httpResponse.isRedirect) {
        final redirectUrl = httpResponse.headers.value(HttpHeaders.locationHeader);
        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          final fixedRedirect = _normalizeUrl(redirectUrl);
          final redirectUri = Uri.parse(fixedRedirect);
          final redirectRequest = await httpClient.openUrl(method, redirectUri);

          // Copiar headers
          headers.forEach((key, value) {
            redirectRequest.headers.set(key, value);
          });

          // Copiar body
          if (body != null) {
            final encodedBody = utf8.encode(json.encode(body));
            redirectRequest.contentLength = encodedBody.length;
            redirectRequest.add(encodedBody);
          }

          final redirectResponse = await redirectRequest.close();
          final redirectBody = await redirectResponse.transform(utf8.decoder).join();

          // Construir Response con headers básicos
          return http.Response(
            redirectBody,
            redirectResponse.statusCode,
            headers: {
              HttpHeaders.contentTypeHeader: redirectResponse.headers.value(HttpHeaders.contentTypeHeader) ?? '',
              HttpHeaders.authorizationHeader: redirectResponse.headers.value(HttpHeaders.authorizationHeader) ?? '',
            },
          );
        }
      }

      final responseBody = await httpResponse.transform(utf8.decoder).join();

      return http.Response(
        responseBody,
        httpResponse.statusCode,
        headers: {
          HttpHeaders.contentTypeHeader: httpResponse.headers.value(HttpHeaders.contentTypeHeader) ?? '',
          HttpHeaders.authorizationHeader: httpResponse.headers.value(HttpHeaders.authorizationHeader) ?? '',
        },
      );
    } finally {
      httpClient.close(force: true);
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return json.decode(response.body);
      } catch (e) {
        return response.body;
      }
    }

    throw Exception('Error en la respuesta: ${response.body}');
  }
}
