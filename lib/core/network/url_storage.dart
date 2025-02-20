/*

  Esta clase, se encarga de establecer los endpoints para usarlos 
  dentro de los services   

*/

class UrlStorage {
//Patron de diseño SINGLETON
//Instancia única
  static final UrlStorage _instance = UrlStorage._internal();
//Constructor privado
  UrlStorage._internal();
//Factory para devolver la misma instancia que esté creada
  factory UrlStorage() {
    return _instance;
  }

/*
                        CAMBIAR EL ACTUAL PUERTO POR LA URL DEL BACK DESPLEGADO
                              |||||||||||||||||||||||||||||||||||||
                              ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
  EJEMPLO:                              
  final String virtualPort = 'https://hermes-back-datacenter.com/';

  UNA VEZ HAYA CAMBIADO EL PUERTO VAYA A LA TERMINAL Y SIGA LOS PASOS DEL MANUAL

*/
  final String virtualPort = 'https://kdx0kl19-8081.use2.devtunnels.ms/';

  // Rutas fijas del Back 
  final String urlCardPerson = 'api/v1/hermesapp/view';
  final String urlLogin = 'api/v1/hermesapp/auth/login';
  final String urlEquipment = 'api/v1/hermesapp/equipment';
  final String urlStudent = 'api/v1/hermesapp/student';
  final String urlPerson = 'api/v1/hermesapp/person';
  final String urlUser = 'api/v1/hermesapp/user';

  // Rutas para el carnet dependiendo el rol
  final Map<String, String> roleEndpoints = {
    "APRENDIZ": "api/v1/hermesapp/card/student",
    "COORDINADOR": "api/v1/hermesapp/card/coordinator",
    "ADMIN": "api/v1/hermesapp/card/admin",
    "SUPER ADMIN": "api/v1/hermesapp/card/superAdmin",
    "SEGURIDAD": "api/v1/hermesapp/card/vigilant",
    "INVITADO": "api/v1/hermesapp/card/guest",
    "INSTRUCTOR": "api/v1/hermesapp/card/teacher",
  };

  //Función para obtener la ruta dependiendo el rol 
  //Params: Rol de la persona y Documento 
  //Return: URL para obtener el carnet
  String getRoleUrl(String role, String document) {
    if (!roleEndpoints.containsKey(role)) {
      throw Exception('Unkown Role');
    }
    return '$virtualPort${roleEndpoints[role]}/$document';
  }
}
