class AuthLogin {
  final int document;
  final String password;
  final String role;

  AuthLogin({
    required this.document,
    required this.password,
    required this.role
  });

  // Convertir JSON a objeto AuthLogin
  factory AuthLogin.fromJson(Map<String, dynamic> json) {
    return AuthLogin(
      role: json['role'],
      document: json['document'],
      password: json['password'],      
    );
  }

  // Convertir objeto AuthLogin a JSON para registrar
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'document': document,
      'password': password
    };
  }
}
