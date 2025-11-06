class UrlStorage {
  // URL base con HTTPS
  final String baseUrl = 'https://hermes.datasena.com/';

  // Routes Back-End - incluyendo el prefijo api/api
  final String urlCardPerson = 'api/api/v1/hermesapp/view';
  final String urlLogin = 'api/api/v1/hermesapp/auth/login';
  final String urlEquipment = 'api/api/v1/hermesapp/equipment';
  final String urlStudent = 'api/api/v1/hermesapp/student';
  final String urlPerson = 'api/api/v1/hermesapp/person';
  final String urlUser = 'api/api/v1/hermesapp/user';

  final Map<String, String> roleEndpoints = {
    "APRENDIZ": "api/api/v1/hermesapp/card/student",
    "COORDINADOR": "api/api/v1/hermesapp/card/coordinator",
    "ADMIN": "api/api/v1/hermesapp/card/admin",
    "SUPER ADMIN": "api/api/v1/hermesapp/card/superAdmin",
    "SEGURIDAD": "api/api/v1/hermesapp/card/vigilant",
    "INVITADO": "api/api/v1/hermesapp/card/guest",
    "INSTRUCTOR": "api/api/v1/hermesapp/card/teacher",
    "ADMINISTRATIVO": "api/api/v1/hermesapp/card/administrativo",
  };

  String getRoleUrl(String role, String document) {
    final endpoint = roleEndpoints[role];
    if (endpoint == null) {
      throw Exception('Rol desconocido: $role');
    }
    return baseUrl + endpoint + '/$document';
  }

  String getUrl(String endpoint) {
    if (endpoint.startsWith('http')) {
      return endpoint;
    }
    return baseUrl + endpoint;
  }
}
