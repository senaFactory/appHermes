class AuthLogin {
  final int document;
  final String password;

  AuthLogin({
    required this.document,
    required this.password,
  });

  // Convertir JSON a objeto AuthLogin
  factory AuthLogin.fromJson(Map<String, dynamic> json) {
    return AuthLogin(
      document: json['document'],
      password: json['password'],
    );
  }

  // Convertir objeto AuthLogin a JSON para registrar
  Map<String, dynamic> toJson() {
    return {
      'document': document,
      'password': password,
    };
  }
}
