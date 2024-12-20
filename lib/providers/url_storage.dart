class UrlStorage {
/*
                        CAMBIAR EL ACTUAL PUERTO POR LA URL DEL BACK DESPLEGADO
                              |||||||||||||||||||||||||||||||||||||
                              ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
  EJEMPLO:                              
  final String virtualPort = 'https://hermes-back-datacenter.com/';

  UNA VEZ HAYA CAMBIADO EL PUERTO VAYA A LA TERMINAL Y SIGA LOS PASOS DEL MANUAL

*/
  final String virtualPort = 'https://hhj97mdq-8081.use2.devtunnels.ms/';

  // Routes Back-End
  final String urlCardPerson = 'api/v1/hermesapp/view';
  final String urlLogin = 'api/v1/hermesapp/auth/login';
  final String urlEquipment = 'api/v1/hermesapp/equipment';
  final String urlStudent = 'api/v1/hermesapp/student';
  final String urlPerson = 'api/v1/hermesapp/person';
  final String urlUser = 'api/v1/hermesapp/user';

  final Map<String, String> roleEndpoints = {
    "APRENDIZ": "api/v1/hermesapp/card/student",
    "COORDINADOR": "api/v1/hermesapp/card/coordinator",
    "ADMIN": "api/v1/hermesapp/card/admin",
    "SUPER ADMIN": "api/v1/hermesapp/card/superAdmin",
    "SEGURIDAD": "api/v1/hermesapp/card/vigilant",
    "INVITADO": "api/v1/hermesapp/card/guest",
    "INSTRUCTOR": "api/v1/hermesapp/card/teacher",
  };

  String getRoleUrl(String role, String document) {
    if (!roleEndpoints.containsKey(role)) {
      throw Exception('Unkown Role');
    }
    return '$virtualPort${roleEndpoints[role]}/$document';
  }
}
