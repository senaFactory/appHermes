class AuthLogin {
  final int document;
  final String password;
  final List<String> roles; // Manejar múltiples roles

  AuthLogin({
    required this.document,
    required this.password,
    required this.roles,
  });

  /// Convertir JSON a objeto AuthLogin
  factory AuthLogin.fromJson(Map<String, dynamic> json) {
    return AuthLogin(
      document: json['document'],
      password: json['jwt'], // Utilizamos el JWT como "password"
      roles: (json['roles'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  /// Convertir objeto AuthLogin a JSON para registrar o depuración
  Map<String, dynamic> toJson() {
    return {
      'document': document,
      'password': password,
      'roles': roles,
    };
  }

  /// Obtener el rol principal o concatenar roles
  String getPrimaryRole() {
    return roles.isNotEmpty ? roles.first : "ROLE_UNKNOWN";
  }
}
